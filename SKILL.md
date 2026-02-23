---
name: alibabacloud-swas
description: |
  阿里云轻量应用服务器 (Simple Application Server / SWAS) Python SDK 调用指南。
  当用户需要管理阿里云轻量应用服务器时使用此技能，包括：创建/启动/停止/重启服务器、
  管理镜像与快照、配置防火墙规则、执行远程命令、管理密钥对、管理轻量数据库、
  查询监控数据、管理标签等。
  触发关键词：阿里云、轻量服务器、SWAS、Simple Application Server、轻量数据库、
  防火墙规则、快照管理、Cloud Assistant、命令助手。
  即使用户只是提到"服务器管理"或"云服务器操作"，如果上下文涉及阿里云轻量服务器，也应使用此技能。
---

# 阿里云轻量应用服务器 SDK 技能

本技能指导 AI 正确使用阿里云轻量应用服务器 (SWAS) Python SDK 调用相关 API。

## SDK 信息

- **包名**: `alibabacloud_swas_open20200601`
- **API 版本**: `2020-06-01`
- **协议**: HTTPS, RPC 风格
- **认证方式**: AccessKey (AK)

## 客户端初始化

```python
from alibabacloud_tea_openapi import models as open_api_models
from alibabacloud_swas_open20200601.client import Client
from alibabacloud_swas_open20200601 import models as swas_models

config = open_api_models.Config(
    access_key_id='<your-access-key-id>',
    access_key_secret='<your-access-key-secret>',
    region_id='cn-hangzhou'  # 根据实际区域修改
)
client = Client(config)
```

> 注意：`access_key_id` 和 `access_key_secret` 是敏感信息，不要硬编码在代码中。建议使用环境变量或配置文件。

## 通用模式

所有 API 调用遵循统一模式：

1. 构造 `XxxRequest` 对象，设置参数
2. 调用 `client.xxx(request)` 获取 `XxxResponse`
3. 通过 `response.body` 访问返回数据

```python
request = swas_models.ListInstancesRequest(
    region_id='cn-hangzhou',
    page_number=1,
    page_size=10
)
response = client.list_instances(request)
# response.body 包含返回的实例列表
```

### 通用参数说明

| 参数 | 说明 |
|------|------|
| `region_id` | 地域 ID，几乎所有接口必填，如 `cn-hangzhou`、`ap-southeast-1` |
| `client_token` | 幂等性令牌，用于保证请求只被执行一次，适用于写操作 |
| `instance_id` | 轻量服务器实例 ID |
| `database_instance_id` | 轻量数据库实例 ID |

## API 分类概览

SDK 提供 **98 个** API，按功能分为以下几大类：

### 1. 实例生命周期管理
管理服务器的创建、启停、重启、升级、续费等。

| API 方法 | 功能 |
|----------|------|
| `list_instances` | 查询实例列表（支持按名称、状态、IP 筛选） |
| `list_instance_status` | 批量查询实例状态 |
| `start_instance` / `start_instances` | 启动单个/批量实例 |
| `stop_instance` / `stop_instances` | 停止单个/批量实例 |
| `reboot_instance` / `reboot_instances` | 重启单个/批量实例 |
| `upgrade_instance` | 升级实例套餐 |
| `renew_instance` | 续费实例 |
| `reset_system` | 重置系统（重装系统或更换镜像） |
| `update_instance_attribute` | 修改实例名称或密码 |
| `list_instance_plans_modification` | 查询可升级的套餐列表 |
| `list_instances_traffic_packages` | 查询流量包使用情况 |

### 2. 镜像管理
管理自定义镜像和系统镜像。

| API 方法 | 功能 |
|----------|------|
| `list_images` | 查询镜像列表（系统/应用/自定义） |
| `list_custom_images` | 查询自定义镜像列表 |
| `create_custom_image` | 创建自定义镜像 |
| `delete_custom_image` | 删除自定义镜像 |
| `modify_image_share_status` | 共享/取消共享镜像到 ECS |
| `add_custom_image_share_account` | 共享镜像到其他阿里云账号 |
| `remove_custom_image_share_account` | 取消跨账号镜像共享 |
| `list_custom_image_share_accounts` | 查询镜像共享账号列表 |

### 3. 磁盘与快照管理
管理数据盘和快照。

| API 方法 | 功能 |
|----------|------|
| `list_disks` | 查询磁盘列表 |
| `update_disk_attribute` | 修改磁盘备注 |
| `reset_disk` | 通过快照回滚磁盘 |
| `list_snapshots` | 查询快照列表 |
| `create_snapshot` | 创建快照 |
| `delete_snapshot` / `delete_snapshots` | 删除单个/批量快照 |
| `update_snapshot_attribute` | 修改快照备注 |

### 4. 防火墙管理
管理防火墙规则和模板。

| API 方法 | 功能 |
|----------|------|
| `list_firewall_rules` | 查询防火墙规则 |
| `create_firewall_rule` | 创建单条防火墙规则 |
| `create_firewall_rules` | 批量创建防火墙规则 |
| `delete_firewall_rules` | 批量删除防火墙规则 |
| `modify_firewall_rule` | 修改防火墙规则 |
| `enable_firewall_rule` / `disable_firewall_rule` | 启用/禁用防火墙规则 |
| `create_firewall_template` | 创建防火墙模板 |
| `modify_firewall_template` | 修改防火墙模板 |
| `delete_firewall_template` | 删除防火墙模板 |
| `describe_firewall_templates` | 查询防火墙模板 |
| `apply_firewall_template` | 应用防火墙模板到实例 |
| `describe_firewall_template_apply_results` | 查询模板应用结果 |
| `describe_firewall_template_rules_apply_result` | 查询模板规则应用结果 |

### 5. 命令与云助手
远程执行命令和管理云助手。

| API 方法 | 功能 |
|----------|------|
| `run_command` | 运行命令（创建并执行） |
| `create_command` | 创建命令（不执行） |
| `invoke_command` | 执行已创建的命令 |
| `describe_commands` | 查询命令列表 |
| `update_command_attribute` | 修改命令属性 |
| `delete_command` | 删除命令 |
| `describe_invocations` | 查询命令执行列表 |
| `describe_invocation_result` | 查询命令执行结果 |
| `describe_command_invocations` | 查询命令执行详情 |
| `install_cloud_assistant` | 安装云助手客户端 |
| `describe_cloud_assistant_status` | 查询云助手安装状态 |
| `describe_cloud_assistant_attributes` | 查询云助手信息 |

### 6. 密钥对管理
管理 SSH 密钥对。

| API 方法 | 功能 |
|----------|------|
| `list_key_pairs` | 查询密钥对列表 |
| `create_key_pair` | 创建密钥对 |
| `import_key_pair` | 导入已有密钥对 |
| `attach_key_pair` | 绑定密钥对到实例 |
| `detach_key_pair` | 解绑密钥对 |
| `delete_key_pairs` | 删除密钥对 |
| `upload_instance_key_pair` | 为实例上传密钥对 |
| `describe_instance_key_pair` | 查询实例密钥对信息 |
| `delete_instance_key_pair` | 删除实例密钥对 |

### 7. 轻量数据库管理
管理 Simple Database Service 实例。

| API 方法 | 功能 |
|----------|------|
| `describe_database_instances` | 查询数据库实例列表 |
| `start_database_instance` | 启动数据库实例 |
| `stop_database_instance` | 停止数据库实例 |
| `restart_database_instance` | 重启数据库实例 |
| `modify_database_instance_description` | 修改数据库实例描述 |
| `modify_database_instance_parameter` | 修改数据库参数 |
| `describe_database_instance_parameters` | 查询数据库参数 |
| `reset_database_account_password` | 重置数据库管理员密码 |
| `allocate_public_connection` | 申请数据库公网地址 |
| `release_public_connection` | 释放数据库公网地址 |
| `describe_database_error_logs` | 查询数据库错误日志 |
| `describe_database_slow_log_records` | 查询数据库慢日志 |
| `describe_database_instance_metric_data` | 查询数据库监控数据 |

### 8. 监控与安全
查询监控数据和安全状态。

| API 方法 | 功能 |
|----------|------|
| `describe_monitor_data` | 查询实例监控数据（CPU、内存、磁盘、流量） |
| `install_cloud_monitor_agent` | 安装云监控插件 |
| `describe_cloud_monitor_agent_statuses` | 查询云监控插件状态 |
| `describe_security_agent_status` | 查询安全中心 Agent 状态 |
| `describe_instance_vnc_url` | 获取 VNC 连接地址 |
| `modify_instance_vnc_password` | 修改 VNC 密码 |
| `describe_instance_passwords_setting` | 查询是否已设置密码 |
| `login_instance` | 通过 Workbench 登录实例 |
| `start_terminal_session` | 创建终端会话 |

### 9. 标签管理

| API 方法 | 功能 |
|----------|------|
| `tag_resources` | 为资源添加标签 |
| `untag_resources` | 移除资源标签 |
| `list_tag_resources` | 查询资源标签 |

### 10. 地域与套餐

| API 方法 | 功能 |
|----------|------|
| `list_regions` | 查询支持的地域列表 |
| `list_plans` | 查询所有套餐信息 |

## 常用代码示例

详细的参数说明和更多代码示例请查看对应的参考文件：

- **实例与镜像操作**: 阅读 `references/instance-and-image-api.md`
- **防火墙与网络操作**: 阅读 `references/firewall-and-network-api.md`
- **命令执行与数据库操作**: 阅读 `references/command-and-database-api.md`
- **磁盘、快照、密钥对与其他操作**: 阅读 `references/disk-snapshot-keypair-api.md`

### 示例 1：查询并启动实例

```python
# 查询所有运行中的实例
req = swas_models.ListInstancesRequest(
    region_id='cn-hangzhou',
    status='Running'
)
resp = client.list_instances(req)
for inst in resp.body.instances:
    print(f"ID: {inst.instance_id}, Name: {inst.instance_name}, IP: {inst.public_ip_address}")

# 启动一个已停止的实例
start_req = swas_models.StartInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxxxxx'
)
client.start_instance(start_req)
```

### 示例 2：创建防火墙规则

```python
req = swas_models.CreateFirewallRuleRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxxxxx',
    port='443/443',
    rule_protocol='TCP',
    remark='HTTPS'
)
resp = client.create_firewall_rule(req)
print(f"防火墙规则 ID: {resp.body.firewall_id}")
```

### 示例 3：在实例上执行命令

```python
req = swas_models.RunCommandRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxxxxx',
    type='RunShellScript',
    command_content='df -h && free -m',
    name='check-disk-memory',
    timeout=60
)
resp = client.run_command(req)
print(f"执行 ID: {resp.body.invoke_id}")
```

### 示例 4：创建快照

```python
req = swas_models.CreateSnapshotRequest(
    region_id='cn-hangzhou',
    disk_id='d-xxxxxx',
    snapshot_name='backup-2024'
)
resp = client.create_snapshot(req)
print(f"快照 ID: {resp.body.snapshot_id}")
```

## 错误处理

```python
from Tea.exceptions import TeaException

try:
    resp = client.list_instances(req)
except TeaException as e:
    print(f"错误码: {e.code}")
    print(f"错误信息: {e.message}")
    print(f"请求 ID: {e.data.get('RequestId', '')}")
```

## 注意事项

1. **region_id 必填**：几乎所有接口都需要指定地域 ID
2. **幂等性**：写操作建议传入 `client_token` 参数（UUID），防止重复操作
3. **批量操作的 ID 格式**：`instance_ids` 等批量参数通常需要 JSON 数组字符串，如 `'["id1","id2"]'`
4. **分页**：列表查询通常支持 `page_number` 和 `page_size`，默认每页 10 条
5. **异步方法**：每个同步方法都有对应的 `async` 版本，如 `list_instances_async`
6. **时间格式**：时间参数通常使用 ISO 8601 格式（UTC），如 `2024-01-01T00:00:00Z`
