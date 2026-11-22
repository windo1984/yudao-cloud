package cn.iocoder.yudao.all.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.BeanDefinitionRegistryPostProcessor;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * 聚合启动（ft-start-all）时移除所有 Feign 客户端 Bean
 *
 * 背景：yudao 的微服务形态里，每个模块的 framework.rpc.config.RpcConfiguration 都会
 * {@code @EnableFeignClients} 注册一批 Feign 客户端代理；而本模块 api 接口
 * 例如 PermissionApi 上标了 {@code @FeignClient(name = "system")}（primary 默认 true），
 * 本地实现 PermissionApiImpl 又标了 {@code @Primary}。
 * 单进程聚合时两者同时存在 → PermissionCommonApi 出现两个 primary 候选 → NoUniqueBeanDefinitionException。
 *
 * 聚合启动后模块间调用实际上走的是同进程内的本地实现（各 *ApiImpl 都是 @RestController/@Service），
 * 因此这里直接把 FeignClientFactoryBean 的 Bean 定义全部摘除，让本地实现成为唯一候选。
 *
 * 说明：仅在 ft-start-all 这个启动模块内生效，不改动任何业务模块的源码。
 */
@Configuration(proxyBeanMethods = false)
public class FeignClientDisableConfiguration implements BeanDefinitionRegistryPostProcessor {

    private static final Logger log = LoggerFactory.getLogger(FeignClientDisableConfiguration.class);

    private static final String FEIGN_CLIENT_FACTORY_BEAN_CLASS = "org.springframework.cloud.openfeign.FeignClientFactoryBean";

    @Override
    public void postProcessBeanDefinitionRegistry(BeanDefinitionRegistry registry) throws BeansException {
        if (!(registry instanceof ConfigurableListableBeanFactory beanFactory)) {
            return;
        }
        List<String> removed = new ArrayList<>();
        for (String beanName : beanFactory.getBeanDefinitionNames()) {
            BeanDefinition definition = beanFactory.getBeanDefinition(beanName);
            if (FEIGN_CLIENT_FACTORY_BEAN_CLASS.equals(definition.getBeanClassName())) {
                registry.removeBeanDefinition(beanName);
                removed.add(beanName);
            }
        }
        log.info("[postProcessBeanDefinitionRegistry] 聚合启动，已移除 {} 个 Feign 客户端 Bean，模块间调用改走同进程本地实现：{}",
                removed.size(), removed);
    }

    @Override
    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) throws BeansException {
        // do nothing
    }

}
