# SQL 未包含的后端实体表

范围：当前后端生产源码的 `@TableName` 声明，减去指定 SQL 的 48 张表，共 453 项。
仅列可核对的实体映射；不是对实际数据库存在性的断言，也不补造缺失 DDL。测试源码和构建产物已排除。

| 模块 | 缺失实体映射数 |
|---|---:|
| yudao-module-ai | 14 |
| yudao-module-bpm | 8 |
| yudao-module-crm | 21 |
| yudao-module-erp | 33 |
| yudao-module-fms | 30 |
| yudao-module-hrm | 50 |
| yudao-module-im | 17 |
| yudao-module-iot | 15 |
| yudao-module-mall | 49 |
| yudao-module-member | 11 |
| yudao-module-mes | 133 |
| yudao-module-mp | 8 |
| yudao-module-pay | 14 |
| yudao-module-pms | 33 |
| yudao-module-report | 1 |
| yudao-module-wms | 16 |

## yudao-module-ai

| 表名 | 实体源码 |
|---|---|
| `ai_api_key` | [AiApiKeyDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiApiKeyDO.java) |
| `ai_chat_conversation` | [AiChatConversationDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/chat/AiChatConversationDO.java) |
| `ai_chat_message` | [AiChatMessageDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/chat/AiChatMessageDO.java) |
| `ai_chat_role` | [AiChatRoleDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiChatRoleDO.java) |
| `ai_image` | [AiImageDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/image/AiImageDO.java) |
| `ai_knowledge` | [AiKnowledgeDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeDO.java) |
| `ai_knowledge_document` | [AiKnowledgeDocumentDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeDocumentDO.java) |
| `ai_knowledge_segment` | [AiKnowledgeSegmentDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/knowledge/AiKnowledgeSegmentDO.java) |
| `ai_mind_map` | [AiMindMapDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/mindmap/AiMindMapDO.java) |
| `ai_model` | [AiModelDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiModelDO.java) |
| `ai_music` | [AiMusicDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/music/AiMusicDO.java) |
| `ai_tool` | [AiToolDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/model/AiToolDO.java) |
| `ai_workflow` | [AiWorkflowDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/workflow/AiWorkflowDO.java) |
| `ai_write` | [AiWriteDO.java](../../yudao-module-ai/yudao-module-ai-server/src/main/java/cn/iocoder/yudao/module/ai/dal/dataobject/write/AiWriteDO.java) |

## yudao-module-bpm

| 表名 | 实体源码 |
|---|---|
| `bpm_category` | [BpmCategoryDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmCategoryDO.java) |
| `bpm_form` | [BpmFormDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmFormDO.java) |
| `bpm_oa_leave` | [BpmOALeaveDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/oa/BpmOALeaveDO.java) |
| `bpm_process_definition_info` | [BpmProcessDefinitionInfoDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessDefinitionInfoDO.java) |
| `bpm_process_expression` | [BpmProcessExpressionDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessExpressionDO.java) |
| `bpm_process_instance_copy` | [BpmProcessInstanceCopyDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/task/BpmProcessInstanceCopyDO.java) |
| `bpm_process_listener` | [BpmProcessListenerDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmProcessListenerDO.java) |
| `bpm_user_group` | [BpmUserGroupDO.java](../../yudao-module-bpm/yudao-module-bpm-server/src/main/java/cn/iocoder/yudao/module/bpm/dal/dataobject/definition/BpmUserGroupDO.java) |

## yudao-module-crm

| 表名 | 实体源码 |
|---|---|
| `crm_business` | [CrmBusinessDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessDO.java) |
| `crm_business_product` | [CrmBusinessProductDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessProductDO.java) |
| `crm_business_status` | [CrmBusinessStatusDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessStatusDO.java) |
| `crm_business_status_type` | [CrmBusinessStatusTypeDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/business/CrmBusinessStatusTypeDO.java) |
| `crm_clue` | [CrmClueDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/clue/CrmClueDO.java) |
| `crm_contact` | [CrmContactDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contact/CrmContactDO.java) |
| `crm_contact_business` | [CrmContactBusinessDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contact/CrmContactBusinessDO.java) |
| `crm_contract` | [CrmContractDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractDO.java) |
| `crm_contract_config` | [CrmContractConfigDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractConfigDO.java) |
| `crm_contract_product` | [CrmContractProductDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/contract/CrmContractProductDO.java) |
| `crm_customer` | [CrmCustomerDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerDO.java) |
| `crm_customer_limit_config` | [CrmCustomerLimitConfigDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerLimitConfigDO.java) |
| `crm_customer_pool_config` | [CrmCustomerPoolConfigDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/customer/CrmCustomerPoolConfigDO.java) |
| `crm_follow_up_record` | [CrmFollowUpRecordDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/followup/CrmFollowUpRecordDO.java) |
| `crm_owner_record` | [CrmOwnerRecordDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/permission/CrmOwnerRecordDO.java) |
| `crm_performance_config` | [CrmPerformanceConfigDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/performance/CrmPerformanceConfigDO.java) |
| `crm_permission` | [CrmPermissionDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/permission/CrmPermissionDO.java) |
| `crm_product` | [CrmProductDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/product/CrmProductDO.java) |
| `crm_product_category` | [CrmProductCategoryDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/product/CrmProductCategoryDO.java) |
| `crm_receivable` | [CrmReceivableDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/receivable/CrmReceivableDO.java) |
| `crm_receivable_plan` | [CrmReceivablePlanDO.java](../../yudao-module-crm/yudao-module-crm-server/src/main/java/cn/iocoder/yudao/module/crm/dal/dataobject/receivable/CrmReceivablePlanDO.java) |

## yudao-module-erp

| 表名 | 实体源码 |
|---|---|
| `erp_account` | [ErpAccountDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpAccountDO.java) |
| `erp_customer` | [ErpCustomerDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpCustomerDO.java) |
| `erp_finance_payment` | [ErpFinancePaymentDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinancePaymentDO.java) |
| `erp_finance_payment_item` | [ErpFinancePaymentItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinancePaymentItemDO.java) |
| `erp_finance_receipt` | [ErpFinanceReceiptDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinanceReceiptDO.java) |
| `erp_finance_receipt_item` | [ErpFinanceReceiptItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/finance/ErpFinanceReceiptItemDO.java) |
| `erp_product` | [ErpProductDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductDO.java) |
| `erp_product_category` | [ErpProductCategoryDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductCategoryDO.java) |
| `erp_product_unit` | [ErpProductUnitDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/product/ErpProductUnitDO.java) |
| `erp_purchase_in` | [ErpPurchaseInDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseInDO.java) |
| `erp_purchase_in_items` | [ErpPurchaseInItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseInItemDO.java) |
| `erp_purchase_order` | [ErpPurchaseOrderDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseOrderDO.java) |
| `erp_purchase_order_items` | [ErpPurchaseOrderItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseOrderItemDO.java) |
| `erp_purchase_return` | [ErpPurchaseReturnDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseReturnDO.java) |
| `erp_purchase_return_items` | [ErpPurchaseReturnItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpPurchaseReturnItemDO.java) |
| `erp_sale_order` | [ErpSaleOrderDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOrderDO.java) |
| `erp_sale_order_items` | [ErpSaleOrderItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOrderItemDO.java) |
| `erp_sale_out` | [ErpSaleOutDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOutDO.java) |
| `erp_sale_out_items` | [ErpSaleOutItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleOutItemDO.java) |
| `erp_sale_return` | [ErpSaleReturnDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleReturnDO.java) |
| `erp_sale_return_items` | [ErpSaleReturnItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/sale/ErpSaleReturnItemDO.java) |
| `erp_stock` | [ErpStockDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockDO.java) |
| `erp_stock_check` | [ErpStockCheckDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockCheckDO.java) |
| `erp_stock_check_item` | [ErpStockCheckItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockCheckItemDO.java) |
| `erp_stock_in` | [ErpStockInDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockInDO.java) |
| `erp_stock_in_item` | [ErpStockInItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockInItemDO.java) |
| `erp_stock_move` | [ErpStockMoveDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockMoveDO.java) |
| `erp_stock_move_item` | [ErpStockMoveItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockMoveItemDO.java) |
| `erp_stock_out` | [ErpStockOutDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockOutDO.java) |
| `erp_stock_out_item` | [ErpStockOutItemDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockOutItemDO.java) |
| `erp_stock_record` | [ErpStockRecordDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpStockRecordDO.java) |
| `erp_supplier` | [ErpSupplierDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/purchase/ErpSupplierDO.java) |
| `erp_warehouse` | [ErpWarehouseDO.java](../../yudao-module-erp/yudao-module-erp-server/src/main/java/cn/iocoder/yudao/module/erp/dal/dataobject/stock/ErpWarehouseDO.java) |

## yudao-module-fms

| 表名 | 实体源码 |
|---|---|
| `fms_account_set` | [FmsAccountSetDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAccountSetDO.java) |
| `fms_account_user` | [FmsAccountUserDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAccountUserDO.java) |
| `fms_assist_combination` | [FmsAuxiliaryCombinationDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryCombinationDO.java) |
| `fms_auxiliary_item` | [FmsAuxiliaryItemDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryItemDO.java) |
| `fms_auxiliary_type` | [FmsAuxiliaryTypeDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsAuxiliaryTypeDO.java) |
| `fms_balance_sheet_config` | [FmsBalanceSheetConfigDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/balance/FmsBalanceSheetConfigDO.java) |
| `fms_balance_sheet_report` | [FmsBalanceSheetReportDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/balance/FmsBalanceSheetReportDO.java) |
| `fms_cash_flow_extend_config` | [FmsCashFlowExtendConfigDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowExtendConfigDO.java) |
| `fms_cash_flow_extend_data` | [FmsCashFlowExtendDataDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowExtendDataDO.java) |
| `fms_cash_flow_statement_config` | [FmsCashFlowStatementConfigDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowStatementConfigDO.java) |
| `fms_cash_flow_statement_report` | [FmsCashFlowStatementReportDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/cashflow/FmsCashFlowStatementReportDO.java) |
| `fms_closing` | [FmsClosingSchemeDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingSchemeDO.java) |
| `fms_closing_period` | [FmsClosingPeriodDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingPeriodDO.java) |
| `fms_closing_template` | [FmsClosingTemplateDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingTemplateDO.java) |
| `fms_closing_voucher` | [FmsClosingVoucherDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/closing/FmsClosingVoucherDO.java) |
| `fms_currency` | [FmsCurrencyDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsCurrencyDO.java) |
| `fms_digest` | [FmsDigestDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsDigestDO.java) |
| `fms_finance_indicator` | [FmsFinanceIndicatorDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsFinanceIndicatorDO.java) |
| `fms_finance_parameter` | [FmsFinanceParameterDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsFinanceParameterDO.java) |
| `fms_income_statement_config` | [FmsIncomeStatementConfigDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/income/FmsIncomeStatementConfigDO.java) |
| `fms_income_statement_report` | [FmsIncomeStatementReportDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/income/FmsIncomeStatementReportDO.java) |
| `fms_initial_balance` | [FmsInitialBalanceDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsInitialBalanceDO.java) |
| `fms_report_template` | [FmsReportTemplateDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/report/FmsReportTemplateDO.java) |
| `fms_subject` | [FmsSubjectDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsSubjectDO.java) |
| `fms_subject_template` | [FmsSubjectTemplateDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsSubjectTemplateDO.java) |
| `fms_voucher` | [FmsVoucherDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/voucher/FmsVoucherDO.java) |
| `fms_voucher_entry` | [FmsVoucherEntryDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/voucher/FmsVoucherEntryDO.java) |
| `fms_voucher_template` | [FmsVoucherTemplateDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherTemplateDO.java) |
| `fms_voucher_template_category` | [FmsVoucherTemplateCategoryDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherTemplateCategoryDO.java) |
| `fms_voucher_word` | [FmsVoucherWordDO.java](../../yudao-module-fms/yudao-module-fms-server/src/main/java/cn/iocoder/yudao/module/fms/dal/dataobject/config/FmsVoucherWordDO.java) |

## yudao-module-hrm

| 表名 | 实体源码 |
|---|---|
| `hrm_attendance_clock` | [HrmAttendanceClockDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/record/HrmAttendanceClockDO.java) |
| `hrm_attendance_group` | [HrmAttendanceGroupDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/config/HrmAttendanceGroupDO.java) |
| `hrm_attendance_holiday` | [HrmAttendanceHolidayDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/config/HrmAttendanceHolidayDO.java) |
| `hrm_attendance_leave` | [HrmAttendanceLeaveDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/attendance/record/HrmAttendanceLeaveDO.java) |
| `hrm_config` | [HrmConfigDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/config/HrmConfigDO.java) |
| `hrm_employee` | [HrmEmployeeDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeDO.java) |
| `hrm_employee_certificate` | [HrmEmployeeCertificateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeCertificateDO.java) |
| `hrm_employee_change_record` | [HrmEmployeeChangeRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeChangeRecordDO.java) |
| `hrm_employee_contact` | [HrmEmployeeContactDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeContactDO.java) |
| `hrm_employee_contract` | [HrmEmployeeContractDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeContractDO.java) |
| `hrm_employee_education_experience` | [HrmEmployeeEducationExperienceDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeEducationExperienceDO.java) |
| `hrm_employee_file` | [HrmEmployeeFileDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeeFileDO.java) |
| `hrm_employee_personal_note` | [HrmEmployeePersonalNoteDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/info/HrmEmployeePersonalNoteDO.java) |
| `hrm_employee_quit_info` | [HrmEmployeeQuitInfoDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeQuitInfoDO.java) |
| `hrm_employee_salary_card` | [HrmEmployeeSalaryCardDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/employment/HrmEmployeeSalaryCardDO.java) |
| `hrm_employee_training_experience` | [HrmEmployeeTrainingExperienceDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeTrainingExperienceDO.java) |
| `hrm_employee_work_experience` | [HrmEmployeeWorkExperienceDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/employee/experience/HrmEmployeeWorkExperienceDO.java) |
| `hrm_insurance_employee_info` | [HrmInsuranceEmployeeInfoDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/employee/HrmInsuranceEmployeeInfoDO.java) |
| `hrm_insurance_month_employee_record` | [HrmInsuranceMonthEmployeeRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/monthrecord/HrmInsuranceMonthEmployeeRecordDO.java) |
| `hrm_insurance_month_record` | [HrmInsuranceMonthRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/monthrecord/HrmInsuranceMonthRecordDO.java) |
| `hrm_insurance_scheme` | [HrmInsuranceSchemeDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/config/HrmInsuranceSchemeDO.java) |
| `hrm_insurance_scheme_project` | [HrmInsuranceSchemeProjectDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/insurance/config/HrmInsuranceSchemeProjectDO.java) |
| `hrm_performance_assessment` | [HrmPerformanceAssessmentDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDO.java) |
| `hrm_performance_assessment_action_record` | [HrmPerformanceAssessmentActionRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentActionRecordDO.java) |
| `hrm_performance_assessment_appeal_record` | [HrmPerformanceAssessmentAppealRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentAppealRecordDO.java) |
| `hrm_performance_assessment_dimension` | [HrmPerformanceAssessmentDimensionDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentDimensionDO.java) |
| `hrm_performance_assessment_quota` | [HrmPerformanceAssessmentQuotaDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentQuotaDO.java) |
| `hrm_performance_assessment_quota_score` | [HrmPerformanceAssessmentQuotaScoreDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentQuotaScoreDO.java) |
| `hrm_performance_assessment_stage` | [HrmPerformanceAssessmentStageDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/assessment/HrmPerformanceAssessmentStageDO.java) |
| `hrm_performance_assessment_template` | [HrmPerformanceAssessmentTemplateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/config/HrmPerformanceAssessmentTemplateDO.java) |
| `hrm_performance_plan` | [HrmPerformancePlanDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/plan/HrmPerformancePlanDO.java) |
| `hrm_performance_result_template` | [HrmPerformanceResultTemplateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/performance/config/HrmPerformanceResultTemplateDO.java) |
| `hrm_recruit_candidate` | [HrmRecruitCandidateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/candidate/HrmRecruitCandidateDO.java) |
| `hrm_recruit_channel` | [HrmRecruitChannelDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/config/HrmRecruitChannelDO.java) |
| `hrm_recruit_interview` | [HrmRecruitInterviewDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/candidate/HrmRecruitInterviewDO.java) |
| `hrm_recruit_post` | [HrmRecruitPostDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/post/HrmRecruitPostDO.java) |
| `hrm_recruit_post_type` | [HrmRecruitPostTypeDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/recruit/post/HrmRecruitPostTypeDO.java) |
| `hrm_salary_change_record` | [HrmSalaryChangeRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/employee/HrmSalaryChangeRecordDO.java) |
| `hrm_salary_change_template` | [HrmSalaryChangeTemplateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryChangeTemplateDO.java) |
| `hrm_salary_config` | [HrmSalaryConfigDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryConfigDO.java) |
| `hrm_salary_employee_info` | [HrmSalaryEmployeeInfoDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/employee/HrmSalaryEmployeeInfoDO.java) |
| `hrm_salary_group` | [HrmSalaryGroupDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryGroupDO.java) |
| `hrm_salary_month_employee_record` | [HrmSalaryMonthEmployeeRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/monthrecord/HrmSalaryMonthEmployeeRecordDO.java) |
| `hrm_salary_month_record` | [HrmSalaryMonthRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/monthrecord/HrmSalaryMonthRecordDO.java) |
| `hrm_salary_option` | [HrmSalaryOptionDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryOptionDO.java) |
| `hrm_salary_option_template` | [HrmSalaryOptionTemplateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryOptionTemplateDO.java) |
| `hrm_salary_slip` | [HrmSalarySlipDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipDO.java) |
| `hrm_salary_slip_send_record` | [HrmSalarySlipSendRecordDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipSendRecordDO.java) |
| `hrm_salary_slip_template` | [HrmSalarySlipTemplateDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/slip/HrmSalarySlipTemplateDO.java) |
| `hrm_salary_tax_rule` | [HrmSalaryTaxRuleDO.java](../../yudao-module-hrm/yudao-module-hrm-server/src/main/java/cn/iocoder/yudao/module/hrm/dal/dataobject/salary/config/HrmSalaryTaxRuleDO.java) |

## yudao-module-im

| 表名 | 实体源码 |
|---|---|
| `im_channel` | [ImChannelDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/channel/ImChannelDO.java) |
| `im_channel_material` | [ImChannelMaterialDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/channel/ImChannelMaterialDO.java) |
| `im_channel_message` | [ImChannelMessageDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImChannelMessageDO.java) |
| `im_conversation_read` | [ImConversationReadDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/conversation/ImConversationReadDO.java) |
| `im_face_pack` | [ImFacePackDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFacePackDO.java) |
| `im_face_pack_item` | [ImFacePackItemDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFacePackItemDO.java) |
| `im_face_user_item` | [ImFaceUserItemDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/face/ImFaceUserItemDO.java) |
| `im_friend` | [ImFriendDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/friend/ImFriendDO.java) |
| `im_friend_request` | [ImFriendRequestDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/friend/ImFriendRequestDO.java) |
| `im_group` | [ImGroupDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupDO.java) |
| `im_group_member` | [ImGroupMemberDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupMemberDO.java) |
| `im_group_message` | [ImGroupMessageDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImGroupMessageDO.java) |
| `im_group_request` | [ImGroupRequestDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/group/ImGroupRequestDO.java) |
| `im_private_message` | [ImPrivateMessageDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/message/ImPrivateMessageDO.java) |
| `im_rtc_call` | [ImRtcCallDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/rtc/ImRtcCallDO.java) |
| `im_rtc_participant` | [ImRtcParticipantDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/rtc/ImRtcParticipantDO.java) |
| `im_sensitive_word` | [ImSensitiveWordDO.java](../../yudao-module-im/yudao-module-im-server/src/main/java/cn/iocoder/yudao/module/im/dal/dataobject/sensitiveword/ImSensitiveWordDO.java) |

## yudao-module-iot

| 表名 | 实体源码 |
|---|---|
| `iot_alert_config` | [IotAlertConfigDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/alert/IotAlertConfigDO.java) |
| `iot_alert_record` | [IotAlertRecordDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/alert/IotAlertRecordDO.java) |
| `iot_data_rule` | [IotDataRuleDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotDataRuleDO.java) |
| `iot_data_sink` | [IotDataSinkDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotDataSinkDO.java) |
| `iot_device` | [IotDeviceDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceDO.java) |
| `iot_device_group` | [IotDeviceGroupDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceGroupDO.java) |
| `iot_device_modbus_config` | [IotDeviceModbusConfigDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceModbusConfigDO.java) |
| `iot_device_modbus_point` | [IotDeviceModbusPointDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/device/IotDeviceModbusPointDO.java) |
| `iot_ota_firmware` | [IotOtaFirmwareDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaFirmwareDO.java) |
| `iot_ota_task` | [IotOtaTaskDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaTaskDO.java) |
| `iot_ota_task_record` | [IotOtaTaskRecordDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/ota/IotOtaTaskRecordDO.java) |
| `iot_product` | [IotProductDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/product/IotProductDO.java) |
| `iot_product_category` | [IotProductCategoryDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/product/IotProductCategoryDO.java) |
| `iot_scene_rule` | [IotSceneRuleDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/rule/IotSceneRuleDO.java) |
| `iot_thing_model` | [IotThingModelDO.java](../../yudao-module-iot/yudao-module-iot-server/src/main/java/cn/iocoder/yudao/module/iot/dal/dataobject/thingmodel/IotThingModelDO.java) |

## yudao-module-mall

| 表名 | 实体源码 |
|---|---|
| `product_brand` | [ProductBrandDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/brand/ProductBrandDO.java) |
| `product_browse_history` | [ProductBrowseHistoryDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/history/ProductBrowseHistoryDO.java) |
| `product_category` | [ProductCategoryDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/category/ProductCategoryDO.java) |
| `product_comment` | [ProductCommentDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/comment/ProductCommentDO.java) |
| `product_favorite` | [ProductFavoriteDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/favorite/ProductFavoriteDO.java) |
| `product_property` | [ProductPropertyDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/property/ProductPropertyDO.java) |
| `product_property_value` | [ProductPropertyValueDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/property/ProductPropertyValueDO.java) |
| `product_sku` | [ProductSkuDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/sku/ProductSkuDO.java) |
| `product_spu` | [ProductSpuDO.java](../../yudao-module-mall/yudao-module-product-server/src/main/java/cn/iocoder/yudao/module/product/dal/dataobject/spu/ProductSpuDO.java) |
| `product_statistics` | [ProductStatisticsDO.java](../../yudao-module-mall/yudao-module-statistics-server/src/main/java/cn/iocoder/yudao/module/statistics/dal/dataobject/product/ProductStatisticsDO.java) |
| `promotion_article` | [ArticleDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/article/ArticleDO.java) |
| `promotion_article_category` | [ArticleCategoryDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/article/ArticleCategoryDO.java) |
| `promotion_banner` | [BannerDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/banner/BannerDO.java) |
| `promotion_bargain_activity` | [BargainActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainActivityDO.java) |
| `promotion_bargain_help` | [BargainHelpDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainHelpDO.java) |
| `promotion_bargain_record` | [BargainRecordDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/bargain/BargainRecordDO.java) |
| `promotion_combination_activity` | [CombinationActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationActivityDO.java) |
| `promotion_combination_product` | [CombinationProductDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationProductDO.java) |
| `promotion_combination_record` | [CombinationRecordDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/combination/CombinationRecordDO.java) |
| `promotion_coupon` | [CouponDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/coupon/CouponDO.java) |
| `promotion_coupon_template` | [CouponTemplateDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/coupon/CouponTemplateDO.java) |
| `promotion_discount_activity` | [DiscountActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/discount/DiscountActivityDO.java) |
| `promotion_discount_product` | [DiscountProductDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/discount/DiscountProductDO.java) |
| `promotion_diy_page` | [DiyPageDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/diy/DiyPageDO.java) |
| `promotion_diy_template` | [DiyTemplateDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/diy/DiyTemplateDO.java) |
| `promotion_kefu_conversation` | [KeFuConversationDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/kefu/KeFuConversationDO.java) |
| `promotion_kefu_message` | [KeFuMessageDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/kefu/KeFuMessageDO.java) |
| `promotion_point_activity` | [PointActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/point/PointActivityDO.java) |
| `promotion_point_product` | [PointProductDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/point/PointProductDO.java) |
| `promotion_reward_activity` | [RewardActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/reward/RewardActivityDO.java) |
| `promotion_seckill_activity` | [SeckillActivityDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillActivityDO.java) |
| `promotion_seckill_config` | [SeckillConfigDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillConfigDO.java) |
| `promotion_seckill_product` | [SeckillProductDO.java](../../yudao-module-mall/yudao-module-promotion-server/src/main/java/cn/iocoder/yudao/module/promotion/dal/dataobject/seckill/SeckillProductDO.java) |
| `trade_after_sale` | [AfterSaleDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/aftersale/AfterSaleDO.java) |
| `trade_after_sale_log` | [AfterSaleLogDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/aftersale/AfterSaleLogDO.java) |
| `trade_brokerage_record` | [BrokerageRecordDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageRecordDO.java) |
| `trade_brokerage_user` | [BrokerageUserDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageUserDO.java) |
| `trade_brokerage_withdraw` | [BrokerageWithdrawDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/brokerage/BrokerageWithdrawDO.java) |
| `trade_cart` | [CartDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/cart/CartDO.java) |
| `trade_config` | [TradeConfigDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/config/TradeConfigDO.java) |
| `trade_delivery_express` | [DeliveryExpressDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressDO.java) |
| `trade_delivery_express_template` | [DeliveryExpressTemplateDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateDO.java) |
| `trade_delivery_express_template_charge` | [DeliveryExpressTemplateChargeDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateChargeDO.java) |
| `trade_delivery_express_template_free` | [DeliveryExpressTemplateFreeDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryExpressTemplateFreeDO.java) |
| `trade_delivery_pick_up_store` | [DeliveryPickUpStoreDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/delivery/DeliveryPickUpStoreDO.java) |
| `trade_order` | [TradeOrderDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderDO.java) |
| `trade_order_item` | [TradeOrderItemDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderItemDO.java) |
| `trade_order_log` | [TradeOrderLogDO.java](../../yudao-module-mall/yudao-module-trade-server/src/main/java/cn/iocoder/yudao/module/trade/dal/dataobject/order/TradeOrderLogDO.java) |
| `trade_statistics` | [TradeStatisticsDO.java](../../yudao-module-mall/yudao-module-statistics-server/src/main/java/cn/iocoder/yudao/module/statistics/dal/dataobject/trade/TradeStatisticsDO.java) |

## yudao-module-member

| 表名 | 实体源码 |
|---|---|
| `member_address` | [MemberAddressDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/address/MemberAddressDO.java) |
| `member_config` | [MemberConfigDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/config/MemberConfigDO.java) |
| `member_experience_record` | [MemberExperienceRecordDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberExperienceRecordDO.java) |
| `member_group` | [MemberGroupDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/group/MemberGroupDO.java) |
| `member_level` | [MemberLevelDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberLevelDO.java) |
| `member_level_record` | [MemberLevelRecordDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/level/MemberLevelRecordDO.java) |
| `member_point_record` | [MemberPointRecordDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/point/MemberPointRecordDO.java) |
| `member_sign_in_config` | [MemberSignInConfigDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/signin/MemberSignInConfigDO.java) |
| `member_sign_in_record` | [MemberSignInRecordDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/signin/MemberSignInRecordDO.java) |
| `member_tag` | [MemberTagDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/tag/MemberTagDO.java) |
| `member_user` | [MemberUserDO.java](../../yudao-module-member/yudao-module-member-server/src/main/java/cn/iocoder/yudao/module/member/dal/dataobject/user/MemberUserDO.java) |

## yudao-module-mes

| 表名 | 实体源码 |
|---|---|
| `mes_cal_holiday` | [MesCalHolidayDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/holiday/MesCalHolidayDO.java) |
| `mes_cal_plan` | [MesCalPlanDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanDO.java) |
| `mes_cal_plan_shift` | [MesCalPlanShiftDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanShiftDO.java) |
| `mes_cal_plan_team` | [MesCalPlanTeamDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/plan/MesCalPlanTeamDO.java) |
| `mes_cal_team` | [MesCalTeamDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamDO.java) |
| `mes_cal_team_member` | [MesCalTeamMemberDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamMemberDO.java) |
| `mes_cal_team_shift` | [MesCalTeamShiftDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/cal/team/MesCalTeamShiftDO.java) |
| `mes_dv_check_plan` | [MesDvCheckPlanDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanDO.java) |
| `mes_dv_check_plan_machinery` | [MesDvCheckPlanMachineryDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanMachineryDO.java) |
| `mes_dv_check_plan_subject` | [MesDvCheckPlanSubjectDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkplan/MesDvCheckPlanSubjectDO.java) |
| `mes_dv_check_record` | [MesDvCheckRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkrecord/MesDvCheckRecordDO.java) |
| `mes_dv_check_record_line` | [MesDvCheckRecordLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/checkrecord/MesDvCheckRecordLineDO.java) |
| `mes_dv_machinery` | [MesDvMachineryDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/machinery/MesDvMachineryDO.java) |
| `mes_dv_machinery_type` | [MesDvMachineryTypeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/machinery/MesDvMachineryTypeDO.java) |
| `mes_dv_mainten_record` | [MesDvMaintenRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/maintenrecord/MesDvMaintenRecordDO.java) |
| `mes_dv_mainten_record_line` | [MesDvMaintenRecordLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/maintenrecord/MesDvMaintenRecordLineDO.java) |
| `mes_dv_repair` | [MesDvRepairDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/repair/MesDvRepairDO.java) |
| `mes_dv_repair_line` | [MesDvRepairLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/repair/MesDvRepairLineDO.java) |
| `mes_dv_subject` | [MesDvSubjectDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/dv/subject/MesDvSubjectDO.java) |
| `mes_md_auto_code_part` | [MesMdAutoCodePartDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodePartDO.java) |
| `mes_md_auto_code_record` | [MesMdAutoCodeRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodeRecordDO.java) |
| `mes_md_auto_code_rule` | [MesMdAutoCodeRuleDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/autocode/MesMdAutoCodeRuleDO.java) |
| `mes_md_client` | [MesMdClientDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/client/MesMdClientDO.java) |
| `mes_md_item` | [MesMdItemDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemDO.java) |
| `mes_md_item_batch_config` | [MesMdItemBatchConfigDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemBatchConfigDO.java) |
| `mes_md_item_type` | [MesMdItemTypeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdItemTypeDO.java) |
| `mes_md_product_bom` | [MesMdProductBomDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductBomDO.java) |
| `mes_md_product_sip` | [MesMdProductSipDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductSipDO.java) |
| `mes_md_product_sop` | [MesMdProductSopDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/item/MesMdProductSopDO.java) |
| `mes_md_unit_measure` | [MesMdUnitMeasureDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/unitmeasure/MesMdUnitMeasureDO.java) |
| `mes_md_vendor` | [MesMdVendorDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/vendor/MesMdVendorDO.java) |
| `mes_md_workshop` | [MesMdWorkshopDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkshopDO.java) |
| `mes_md_workstation` | [MesMdWorkstationDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationDO.java) |
| `mes_md_workstation_machine` | [MesMdWorkstationMachineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationMachineDO.java) |
| `mes_md_workstation_tool` | [MesMdWorkstationToolDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationToolDO.java) |
| `mes_md_workstation_worker` | [MesMdWorkstationWorkerDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/md/workstation/MesMdWorkstationWorkerDO.java) |
| `mes_pro_andon_config` | [MesProAndonConfigDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/andon/MesProAndonConfigDO.java) |
| `mes_pro_andon_record` | [MesProAndonRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/andon/MesProAndonRecordDO.java) |
| `mes_pro_card` | [MesProCardDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/card/MesProCardDO.java) |
| `mes_pro_card_process` | [MesProCardProcessDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/card/MesProCardProcessDO.java) |
| `mes_pro_feedback` | [MesProFeedbackDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/feedback/MesProFeedbackDO.java) |
| `mes_pro_process` | [MesProProcessDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/process/MesProProcessDO.java) |
| `mes_pro_process_content` | [MesProProcessContentDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/process/MesProProcessContentDO.java) |
| `mes_pro_route` | [MesProRouteDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteDO.java) |
| `mes_pro_route_process` | [MesProRouteProcessDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProcessDO.java) |
| `mes_pro_route_product` | [MesProRouteProductDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProductDO.java) |
| `mes_pro_route_product_bom` | [MesProRouteProductBomDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/route/MesProRouteProductBomDO.java) |
| `mes_pro_task` | [MesProTaskDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/task/MesProTaskDO.java) |
| `mes_pro_task_issue` | [MesProTaskIssueDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/task/MesProTaskIssueDO.java) |
| `mes_pro_work_order` | [MesProWorkOrderDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workorder/MesProWorkOrderDO.java) |
| `mes_pro_work_order_bom` | [MesProWorkOrderBomDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workorder/MesProWorkOrderBomDO.java) |
| `mes_pro_work_record` | [MesProWorkRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workrecord/MesProWorkRecordDO.java) |
| `mes_pro_work_record_log` | [MesProWorkRecordLogDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/pro/workrecord/MesProWorkRecordLogDO.java) |
| `mes_qc_defect` | [MesQcDefectDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/defect/MesQcDefectDO.java) |
| `mes_qc_defect_record` | [MesQcDefectRecordDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/defectrecord/MesQcDefectRecordDO.java) |
| `mes_qc_indicator` | [MesQcIndicatorDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicator/MesQcIndicatorDO.java) |
| `mes_qc_indicator_result` | [MesQcIndicatorResultDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicatorresult/MesQcIndicatorResultDO.java) |
| `mes_qc_indicator_result_detail` | [MesQcIndicatorResultDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/indicatorresult/MesQcIndicatorResultDetailDO.java) |
| `mes_qc_ipqc` | [MesQcIpqcDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/ipqc/MesQcIpqcDO.java) |
| `mes_qc_ipqc_line` | [MesQcIpqcLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/ipqc/MesQcIpqcLineDO.java) |
| `mes_qc_iqc` | [MesQcIqcDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/iqc/MesQcIqcDO.java) |
| `mes_qc_iqc_line` | [MesQcIqcLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/iqc/MesQcIqcLineDO.java) |
| `mes_qc_oqc` | [MesQcOqcDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/oqc/MesQcOqcDO.java) |
| `mes_qc_oqc_line` | [MesQcOqcLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/oqc/MesQcOqcLineDO.java) |
| `mes_qc_rqc` | [MesQcRqcDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/rqc/MesQcRqcDO.java) |
| `mes_qc_rqc_line` | [MesQcRqcLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/rqc/MesQcRqcLineDO.java) |
| `mes_qc_template` | [MesQcTemplateDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateDO.java) |
| `mes_qc_template_indicator` | [MesQcTemplateIndicatorDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateIndicatorDO.java) |
| `mes_qc_template_item` | [MesQcTemplateItemDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/qc/template/MesQcTemplateItemDO.java) |
| `mes_tm_tool` | [MesTmToolDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/tm/tool/MesTmToolDO.java) |
| `mes_tm_tool_type` | [MesTmToolTypeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/tm/tool/MesTmToolTypeDO.java) |
| `mes_wm_arrival_notice` | [MesWmArrivalNoticeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/arrivalnotice/MesWmArrivalNoticeDO.java) |
| `mes_wm_arrival_notice_line` | [MesWmArrivalNoticeLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/arrivalnotice/MesWmArrivalNoticeLineDO.java) |
| `mes_wm_barcode` | [MesWmBarcodeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/barcode/MesWmBarcodeDO.java) |
| `mes_wm_barcode_config` | [MesWmBarcodeConfigDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/barcode/MesWmBarcodeConfigDO.java) |
| `mes_wm_batch` | [MesWmBatchDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/batch/MesWmBatchDO.java) |
| `mes_wm_item_consume` | [MesWmItemConsumeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeDO.java) |
| `mes_wm_item_consume_detail` | [MesWmItemConsumeDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeDetailDO.java) |
| `mes_wm_item_consume_line` | [MesWmItemConsumeLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemconsume/MesWmItemConsumeLineDO.java) |
| `mes_wm_item_receipt` | [MesWmItemReceiptDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptDO.java) |
| `mes_wm_item_receipt_detail` | [MesWmItemReceiptDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptDetailDO.java) |
| `mes_wm_item_receipt_line` | [MesWmItemReceiptLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/itemreceipt/MesWmItemReceiptLineDO.java) |
| `mes_wm_material_stock` | [MesWmMaterialStockDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/materialstock/MesWmMaterialStockDO.java) |
| `mes_wm_misc_issue` | [MesWmMiscIssueDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueDO.java) |
| `mes_wm_misc_issue_detail` | [MesWmMiscIssueDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueDetailDO.java) |
| `mes_wm_misc_issue_line` | [MesWmMiscIssueLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscissue/MesWmMiscIssueLineDO.java) |
| `mes_wm_misc_receipt` | [MesWmMiscReceiptDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptDO.java) |
| `mes_wm_misc_receipt_detail` | [MesWmMiscReceiptDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptDetailDO.java) |
| `mes_wm_misc_receipt_line` | [MesWmMiscReceiptLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/miscreceipt/MesWmMiscReceiptLineDO.java) |
| `mes_wm_outsource_issue` | [MesWmOutsourceIssueDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueDO.java) |
| `mes_wm_outsource_issue_detail` | [MesWmOutsourceIssueDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueDetailDO.java) |
| `mes_wm_outsource_issue_line` | [MesWmOutsourceIssueLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourceissue/MesWmOutsourceIssueLineDO.java) |
| `mes_wm_outsource_receipt` | [MesWmOutsourceReceiptDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptDO.java) |
| `mes_wm_outsource_receipt_detail` | [MesWmOutsourceReceiptDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptDetailDO.java) |
| `mes_wm_outsource_receipt_line` | [MesWmOutsourceReceiptLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/outsourcereceipt/MesWmOutsourceReceiptLineDO.java) |
| `mes_wm_package` | [MesWmPackageDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/packages/MesWmPackageDO.java) |
| `mes_wm_package_line` | [MesWmPackageLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/packages/MesWmPackageLineDO.java) |
| `mes_wm_product_issue` | [MesWmProductIssueDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueDO.java) |
| `mes_wm_product_issue_detail` | [MesWmProductIssueDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueDetailDO.java) |
| `mes_wm_product_issue_line` | [MesWmProductIssueLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productissue/MesWmProductIssueLineDO.java) |
| `mes_wm_product_produce` | [MesWmProductProduceDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceDO.java) |
| `mes_wm_product_produce_detail` | [MesWmProductProduceDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceDetailDO.java) |
| `mes_wm_product_produce_line` | [MesWmProductProduceLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productproduce/MesWmProductProduceLineDO.java) |
| `mes_wm_product_receipt` | [MesWmProductReceiptDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptDO.java) |
| `mes_wm_product_receipt_detail` | [MesWmProductReceiptDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptDetailDO.java) |
| `mes_wm_product_receipt_line` | [MesWmProductReceiptLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productreceipt/MesWmProductReceiptLineDO.java) |
| `mes_wm_product_sales` | [MesWmProductSalesDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesDO.java) |
| `mes_wm_product_sales_detail` | [MesWmProductSalesDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesDetailDO.java) |
| `mes_wm_product_sales_line` | [MesWmProductSalesLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/productsales/MesWmProductSalesLineDO.java) |
| `mes_wm_return_issue` | [MesWmReturnIssueDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueDO.java) |
| `mes_wm_return_issue_detail` | [MesWmReturnIssueDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueDetailDO.java) |
| `mes_wm_return_issue_line` | [MesWmReturnIssueLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnissue/MesWmReturnIssueLineDO.java) |
| `mes_wm_return_sales` | [MesWmReturnSalesDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesDO.java) |
| `mes_wm_return_sales_detail` | [MesWmReturnSalesDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesDetailDO.java) |
| `mes_wm_return_sales_line` | [MesWmReturnSalesLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnsales/MesWmReturnSalesLineDO.java) |
| `mes_wm_return_vendor` | [MesWmReturnVendorDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorDO.java) |
| `mes_wm_return_vendor_detail` | [MesWmReturnVendorDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorDetailDO.java) |
| `mes_wm_return_vendor_line` | [MesWmReturnVendorLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/returnvendor/MesWmReturnVendorLineDO.java) |
| `mes_wm_sales_notice` | [MesWmSalesNoticeDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/salesnotice/MesWmSalesNoticeDO.java) |
| `mes_wm_sales_notice_line` | [MesWmSalesNoticeLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/salesnotice/MesWmSalesNoticeLineDO.java) |
| `mes_wm_sn` | [MesWmSnDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/sn/MesWmSnDO.java) |
| `mes_wm_stock_taking_plan` | [MesWmStockTakingPlanDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/plan/MesWmStockTakingPlanDO.java) |
| `mes_wm_stock_taking_plan_param` | [MesWmStockTakingPlanParamDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/plan/MesWmStockTakingPlanParamDO.java) |
| `mes_wm_stock_taking_task` | [MesWmStockTakingTaskDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskDO.java) |
| `mes_wm_stock_taking_task_line` | [MesWmStockTakingTaskLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskLineDO.java) |
| `mes_wm_stock_taking_task_result` | [MesWmStockTakingTaskResultDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/stocktaking/task/MesWmStockTakingTaskResultDO.java) |
| `mes_wm_transaction` | [MesWmTransactionDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transaction/MesWmTransactionDO.java) |
| `mes_wm_transfer` | [MesWmTransferDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferDO.java) |
| `mes_wm_transfer_detail` | [MesWmTransferDetailDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferDetailDO.java) |
| `mes_wm_transfer_line` | [MesWmTransferLineDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/transfer/MesWmTransferLineDO.java) |
| `mes_wm_warehouse` | [MesWmWarehouseDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseDO.java) |
| `mes_wm_warehouse_area` | [MesWmWarehouseAreaDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseAreaDO.java) |
| `mes_wm_warehouse_location` | [MesWmWarehouseLocationDO.java](../../yudao-module-mes/yudao-module-mes-server/src/main/java/cn/iocoder/yudao/module/mes/dal/dataobject/wm/warehouse/MesWmWarehouseLocationDO.java) |

## yudao-module-mp

| 表名 | 实体源码 |
|---|---|
| `mp_account` | [MpAccountDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/account/MpAccountDO.java) |
| `mp_auto_reply` | [MpAutoReplyDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpAutoReplyDO.java) |
| `mp_material` | [MpMaterialDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/material/MpMaterialDO.java) |
| `mp_menu` | [MpMenuDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/menu/MpMenuDO.java) |
| `mp_message` | [MpMessageDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpMessageDO.java) |
| `mp_message_template` | [MpMessageTemplateDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/message/MpMessageTemplateDO.java) |
| `mp_tag` | [MpTagDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/tag/MpTagDO.java) |
| `mp_user` | [MpUserDO.java](../../yudao-module-mp/yudao-module-mp-server/src/main/java/cn/iocoder/yudao/module/mp/dal/dataobject/user/MpUserDO.java) |

## yudao-module-pay

| 表名 | 实体源码 |
|---|---|
| `pay_app` | [PayAppDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/app/PayAppDO.java) |
| `pay_channel` | [PayChannelDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/channel/PayChannelDO.java) |
| `pay_demo_order` | [PayDemoOrderDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/demo/PayDemoOrderDO.java) |
| `pay_demo_withdraw` | [PayDemoWithdrawDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/demo/PayDemoWithdrawDO.java) |
| `pay_notify_log` | [PayNotifyLogDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/notify/PayNotifyLogDO.java) |
| `pay_notify_task` | [PayNotifyTaskDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/notify/PayNotifyTaskDO.java) |
| `pay_order` | [PayOrderDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/order/PayOrderDO.java) |
| `pay_order_extension` | [PayOrderExtensionDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/order/PayOrderExtensionDO.java) |
| `pay_refund` | [PayRefundDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/refund/PayRefundDO.java) |
| `pay_transfer` | [PayTransferDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/transfer/PayTransferDO.java) |
| `pay_wallet` | [PayWalletDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletDO.java) |
| `pay_wallet_recharge` | [PayWalletRechargeDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletRechargeDO.java) |
| `pay_wallet_recharge_package` | [PayWalletRechargePackageDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletRechargePackageDO.java) |
| `pay_wallet_transaction` | [PayWalletTransactionDO.java](../../yudao-module-pay/yudao-module-pay-server/src/main/java/cn/iocoder/yudao/module/pay/dal/dataobject/wallet/PayWalletTransactionDO.java) |

## yudao-module-pms

| 表名 | 实体源码 |
|---|---|
| `pms_iteration` | [PmsIterationDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/iteration/PmsIterationDO.java) |
| `pms_knowledge_content_permission` | [PmsKnowledgeContentPermissionDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeContentPermissionDO.java) |
| `pms_knowledge_content_permission_member` | [PmsKnowledgeContentPermissionMemberDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeContentPermissionMemberDO.java) |
| `pms_knowledge_document` | [PmsKnowledgeDocumentDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeDocumentDO.java) |
| `pms_knowledge_document_comment` | [PmsKnowledgeDocumentCommentDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentCommentDO.java) |
| `pms_knowledge_document_label` | [PmsKnowledgeDocumentLabelDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeDocumentLabelDO.java) |
| `pms_knowledge_document_like` | [PmsKnowledgeDocumentLikeDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentLikeDO.java) |
| `pms_knowledge_document_share` | [PmsKnowledgeDocumentShareDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeDocumentShareDO.java) |
| `pms_knowledge_favorite` | [PmsKnowledgeFavoriteDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeFavoriteDO.java) |
| `pms_knowledge_folder` | [PmsKnowledgeFolderDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/content/PmsKnowledgeFolderDO.java) |
| `pms_knowledge_group` | [PmsKnowledgeGroupDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeGroupDO.java) |
| `pms_knowledge_group_relation` | [PmsKnowledgeGroupRelationDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeGroupRelationDO.java) |
| `pms_knowledge_library` | [PmsKnowledgeLibraryDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryDO.java) |
| `pms_knowledge_library_member` | [PmsKnowledgeLibraryMemberDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryMemberDO.java) |
| `pms_knowledge_library_template` | [PmsKnowledgeLibraryTemplateDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/library/PmsKnowledgeLibraryTemplateDO.java) |
| `pms_knowledge_recycle_record` | [PmsKnowledgeRecycleRecordDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/recycle/PmsKnowledgeRecycleRecordDO.java) |
| `pms_knowledge_view_record` | [PmsKnowledgeViewRecordDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/kb/interaction/PmsKnowledgeViewRecordDO.java) |
| `pms_project` | [PmsProjectDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectDO.java) |
| `pms_project_announcement` | [PmsProjectAnnouncementDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectAnnouncementDO.java) |
| `pms_project_favorite` | [PmsProjectFavoriteDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectFavoriteDO.java) |
| `pms_project_group` | [PmsProjectGroupDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectGroupDO.java) |
| `pms_project_group_relation` | [PmsProjectGroupRelationDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectGroupRelationDO.java) |
| `pms_project_member` | [PmsProjectMemberDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectMemberDO.java) |
| `pms_project_template` | [PmsProjectTemplateDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/project/PmsProjectTemplateDO.java) |
| `pms_work_item` | [PmsWorkItemDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemDO.java) |
| `pms_work_item_activity` | [PmsWorkItemActivityDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemActivityDO.java) |
| `pms_work_item_board` | [PmsWorkItemBoardDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemBoardDO.java) |
| `pms_work_item_comment` | [PmsWorkItemCommentDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemCommentDO.java) |
| `pms_work_item_label` | [PmsWorkItemLabelDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemLabelDO.java) |
| `pms_work_item_member` | [PmsWorkItemMemberDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemMemberDO.java) |
| `pms_work_item_status` | [PmsWorkItemStatusDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemStatusDO.java) |
| `pms_work_item_user_sort` | [PmsWorkItemUserSortDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemUserSortDO.java) |
| `pms_work_item_work_log` | [PmsWorkItemWorkLogDO.java](../../yudao-module-pms/yudao-module-pms-server/src/main/java/cn/iocoder/yudao/module/pms/dal/dataobject/pm/workitem/PmsWorkItemWorkLogDO.java) |

## yudao-module-report

| 表名 | 实体源码 |
|---|---|
| `report_go_view_project` | [GoViewProjectDO.java](../../yudao-module-report/yudao-module-report-server/src/main/java/cn/iocoder/yudao/module/report/dal/dataobject/goview/GoViewProjectDO.java) |

## yudao-module-wms

| 表名 | 实体源码 |
|---|---|
| `wms_check_order` | [WmsCheckOrderDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/check/WmsCheckOrderDO.java) |
| `wms_check_order_detail` | [WmsCheckOrderDetailDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/check/WmsCheckOrderDetailDO.java) |
| `wms_inventory` | [WmsInventoryDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/inventory/WmsInventoryDO.java) |
| `wms_inventory_history` | [WmsInventoryHistoryDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/inventory/WmsInventoryHistoryDO.java) |
| `wms_item` | [WmsItemDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemDO.java) |
| `wms_item_brand` | [WmsItemBrandDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemBrandDO.java) |
| `wms_item_category` | [WmsItemCategoryDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemCategoryDO.java) |
| `wms_item_sku` | [WmsItemSkuDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/item/WmsItemSkuDO.java) |
| `wms_merchant` | [WmsMerchantDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/merchant/WmsMerchantDO.java) |
| `wms_movement_order` | [WmsMovementOrderDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/movement/WmsMovementOrderDO.java) |
| `wms_movement_order_detail` | [WmsMovementOrderDetailDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/movement/WmsMovementOrderDetailDO.java) |
| `wms_receipt_order` | [WmsReceiptOrderDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/receipt/WmsReceiptOrderDO.java) |
| `wms_receipt_order_detail` | [WmsReceiptOrderDetailDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/receipt/WmsReceiptOrderDetailDO.java) |
| `wms_shipment_order` | [WmsShipmentOrderDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/shipment/WmsShipmentOrderDO.java) |
| `wms_shipment_order_detail` | [WmsShipmentOrderDetailDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/order/shipment/WmsShipmentOrderDetailDO.java) |
| `wms_warehouse` | [WmsWarehouseDO.java](../../yudao-module-wms/yudao-module-wms-server/src/main/java/cn/iocoder/yudao/module/wms/dal/dataobject/md/warehouse/WmsWarehouseDO.java) |
