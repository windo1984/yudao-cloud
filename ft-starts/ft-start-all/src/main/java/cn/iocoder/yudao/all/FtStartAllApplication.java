package cn.iocoder.yudao.all;

import cn.iocoder.yudao.all.config.ChatClientFallbackConfiguration;
import cn.iocoder.yudao.all.config.FeignClientDisableConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Import;

/**
 * 全模块聚合启动类：一个进程加载所有 yudao 业务模块
 *
 * 注意 1：scanBasePackages 使用 ${yudao.info.base-package}.module，要求 yudao.info.base-package = cn.iocoder.yudao
 * 注意 2：{@link FeignClientDisableConfiguration} 移除各模块 RpcConfiguration 注册的 Feign 客户端，
 *        避免 Feign 代理与本地 *ApiImpl 同时成为 @Primary 候选
 * 注意 3：{@link ChatClientFallbackConfiguration} 提供唯一 ChatClient.Builder，避免多 ChatModel 时
 *        Spring AI 的 ChatClientAutoConfiguration 与积木报表 AI 助手互斥
 */
@SuppressWarnings("SpringComponentScan")
@Import({FeignClientDisableConfiguration.class, ChatClientFallbackConfiguration.class})
@SpringBootApplication(scanBasePackages = {"${yudao.info.base-package}.module"})
public class FtStartAllApplication {

    public static void main(String[] args) {
        SpringApplication.run(FtStartAllApplication.class, args);
    }

}