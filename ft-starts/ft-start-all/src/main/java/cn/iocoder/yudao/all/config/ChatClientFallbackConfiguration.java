package cn.iocoder.yudao.all.config;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.config.ConfigurableListableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

/**
 * 聚合启动时提供唯一的 ChatClient.Builder
 *
 * 背景：Spring AI 的 ChatClientAutoConfiguration#chatClientBuilder 要求容器里只有一个 ChatModel，
 * 而聚合后同时存在 11 个（yudao 自己的 tongYiChatModel / douBaoChatClient 等 + Spring AI 的
 * openAiChatModel / anthropicChatModel / ollamaChatModel 等）。积木报表（jimureport）的
 * JimuAiAutoConfiguration 又要注入 ChatClient.Builder，于是启动时抛
 * “Parameter 2 of method chatClientBuilder required a single bean, but 11 were found”。
 *
 * 该自动配置方法带 @ConditionalOnMissingBean，这里提供一个 @Primary 的 Builder 后它就不会再创建，
 * 需要 Builder 的三方 starter（积木报表 AI 助手）就能拿到唯一实例。
 *
 * 说明：仅在 ft-start-all 启动模块内生效，不改动任何业务模块的源码。
 */
@Configuration(proxyBeanMethods = false)
public class ChatClientFallbackConfiguration {

    private static final String PREFERRED_CHAT_MODEL_BEAN = "openAiChatModel";

    /**
     * 优先取 Spring AI 的 openAiChatModel（存在性由 openai starter 决定），否则退化为任取一个 ChatModel
     */
    @Bean(name = "chatClientBuilder")
    @Primary
    public ChatClient.Builder chatClientBuilder(ConfigurableListableBeanFactory beanFactory,
                                                ObjectProvider<ChatModel> chatModels) {
        ChatModel chatModel = beanFactory.containsBean(PREFERRED_CHAT_MODEL_BEAN)
                ? beanFactory.getBean(PREFERRED_CHAT_MODEL_BEAN, ChatModel.class)
                : chatModels.orderedStream().findFirst()
                        .orElseThrow(() -> new IllegalStateException("聚合启动未发现任何 ChatModel，无法为三方组件构建 ChatClient.Builder"));
        return ChatClient.builder(chatModel);
    }

}
