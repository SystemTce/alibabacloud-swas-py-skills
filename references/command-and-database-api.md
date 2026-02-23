# 命令执行与数据库 API 详细参考

## 命令与云助手

### run_command - 运行命令（创建并执行）

```python
req = swas_models.RunCommandRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',       # 必填
    type='RunShellScript',        # 必填：RunShellScript / RunBatScript / RunPowerShellScript
    command_content='df -h',      # 必填，命令内容，支持 {{}} 自定义参数
    name='check-disk',            # 必填，命令名称
    timeout=60,                   # 可选，超时秒数，10-86400，默认 60
    enable_parameter=False,       # 可选，是否启用自定义参数
    parameters={'name': 'test'},  # 可选，自定义参数键值对
    working_dir='/root',          # 可选，执行路径，Linux 默认 /root
    working_user='root',          # 可选，执行用户，Linux 默认 root
    windows_password_name='xxx'   # 可选，Windows 非默认用户密码名称
)
resp = client.run_command(req)
print(f"执行 ID: {resp.body.invoke_id}")
```

### create_command - 创建命令（不执行）

```python
req = swas_models.CreateCommandRequest(
    region_id='cn-hangzhou',
    name='restart-nginx',                # 必填
    type='RunShellScript',               # 必填
    command_content='systemctl restart nginx',  # 必填
    description='重启 Nginx 服务',        # 可选
    timeout=60,                          # 可选
    working_dir='/root',                 # 可选
    enable_parameter=False,              # 可选
    resource_group_id='rg-xxx',          # 可选
    tag=[swas_models.CreateCommandRequestTag(key='type', value='ops')]
)
resp = client.create_command(req)
print(f"命令 ID: {resp.body.command_id}")
```

### invoke_command - 执行已创建的命令

```python
req = swas_models.InvokeCommandRequest(
    region_id='cn-hangzhou',
    command_id='cmd-xxx',                 # 必填
    instance_ids='["id1","id2"]',         # 必填，JSON 数组，最多 50 个
    parameters={'key': 'value'},          # 可选
    username='root'                       # 可选，执行用户
)
resp = client.invoke_command(req)
print(f"执行 ID: {resp.body.invoke_id}")
```

### describe_commands - 查询命令列表

```python
req = swas_models.DescribeCommandsRequest(
    region_id='cn-hangzhou',
    command_id='cmd-xxx',       # 可选
    name='restart',             # 可选，不支持模糊匹配
    type='RunShellScript',      # 可选
    provider='AlibabaCloud',    # 可选，查询公共命令
    resource_group_id='rg-xxx', # 可选
    page_number=1,
    page_size=10,
    tag=[swas_models.DescribeCommandsRequestTag(key='type', value='ops')]
)
resp = client.describe_commands(req)
```

### update_command_attribute - 修改命令属性

```python
req = swas_models.UpdateCommandAttributeRequest(
    region_id='cn-hangzhou',
    command_id='cmd-xxx',       # 必填
    name='new-name',            # 可选，最大 128 字符
    description='new desc',     # 可选，最大 512 字符
    timeout=120,                # 可选
    working_dir='/home/user'    # 可选，最大 200 字符
)
client.update_command_attribute(req)
```

### delete_command - 删除命令

```python
req = swas_models.DeleteCommandRequest(
    region_id='cn-hangzhou',
    command_id='cmd-xxx'
)
client.delete_command(req)
```

### describe_invocations - 查询命令执行列表

```python
req = swas_models.DescribeInvocationsRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',     # 必填
    invoke_status='Running',    # 可选：Running / Finished / Failed
    page_number=1,
    page_size=10
)
resp = client.describe_invocations(req)
```

### describe_invocation_result - 查询命令执行结果

```python
req = swas_models.DescribeInvocationResultRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',  # 必填
    invoke_id='inv-xxx'      # 必填
)
resp = client.describe_invocation_result(req)
# 最近两周的执行结果可查，最多保留 10 万条
```

### describe_command_invocations - 查询命令执行详情

```python
req = swas_models.DescribeCommandInvocationsRequest(
    region_id='cn-hangzhou',
    command_id='cmd-xxx',          # 可选
    command_name='restart',        # 可选
    command_type='RunShellScript', # 可选
    instance_id='ace57xxx',        # 可选
    invoke_id='inv-xxx',           # 可选
    invocation_status='Success',   # 可选：Pending/Running/Success/Failed/Stopping/Stopped/PartialFailed
    page_number=1,
    page_size=10
)
resp = client.describe_command_invocations(req)
```

### install_cloud_assistant - 安装云助手客户端

```python
req = swas_models.InstallCloudAssistantRequest(
    region_id='cn-hangzhou',
    instance_ids=['id1', 'id2']  # 必填
)
client.install_cloud_assistant(req)
# 安装后需调用 reboot_instance 重启使客户端生效
```

### describe_cloud_assistant_status - 查询云助手安装状态

```python
req = swas_models.DescribeCloudAssistantStatusRequest(
    region_id='cn-hangzhou',
    instance_ids=['id1', 'id2'],  # 必填
    page_number=1,
    page_size=10
)
resp = client.describe_cloud_assistant_status(req)
# 默认已安装，手动卸载后需重新安装
```

### describe_cloud_assistant_attributes - 查询云助手信息

```python
req = swas_models.DescribeCloudAssistantAttributesRequest(
    region_id='cn-hangzhou',
    instance_ids=['id1'],
    page_number=1,
    page_size=10
)
resp = client.describe_cloud_assistant_attributes(req)
```

---

## 轻量数据库管理

### describe_database_instances - 查询数据库实例列表

```python
req = swas_models.DescribeDatabaseInstancesRequest(
    region_id='cn-hangzhou',
    database_instance_ids='["db-id1","db-id2"]',  # 可选，JSON 数组，最多 100 个
    page_number=1,
    page_size=10
)
resp = client.describe_database_instances(req)
# 返回实例 ID、名称、套餐、数据库版本、公网/内网地址、创建/到期时间等
```

### start_database_instance - 启动数据库实例

```python
req = swas_models.StartDatabaseInstanceRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'  # 必填，须为 Stopped 状态
)
client.start_database_instance(req)
```

### stop_database_instance - 停止数据库实例

```python
req = swas_models.StopDatabaseInstanceRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'  # 必填，须为 Running 状态
)
client.stop_database_instance(req)
# 停止后无法登录和访问
```

### restart_database_instance - 重启数据库实例

```python
req = swas_models.RestartDatabaseInstanceRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'  # 必填，须为 Running 状态
)
client.restart_database_instance(req)
# QPS 限制：每分钟 10 次
```

### modify_database_instance_description - 修改数据库描述

```python
req = swas_models.ModifyDatabaseInstanceDescriptionRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    database_instance_description='生产环境数据库'  # 必填
)
client.modify_database_instance_description(req)
```

### describe_database_instance_parameters - 查询数据库参数

```python
req = swas_models.DescribeDatabaseInstanceParametersRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'
)
resp = client.describe_database_instance_parameters(req)
```

### modify_database_instance_parameter - 修改数据库参数

```python
req = swas_models.ModifyDatabaseInstanceParameterRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    parameters='{"max_connections":"200"}',  # JSON 字符串
    force_restart=False  # 可选，是否强制重启
)
client.modify_database_instance_parameter(req)
```

### reset_database_account_password - 重置数据库密码

```python
req = swas_models.ResetDatabaseAccountPasswordRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    account_password='NewSecurePass123!'  # 必填
)
client.reset_database_account_password(req)
```

### describe_database_error_logs - 查询数据库错误日志

```python
req = swas_models.DescribeDatabaseErrorLogsRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    start_time='2024-01-01T00:00:00Z',  # ISO 8601 UTC
    end_time='2024-01-02T00:00:00Z',
    page_number=1,
    page_size=10
)
resp = client.describe_database_error_logs(req)
```

### describe_database_slow_log_records - 查询慢日志

```python
req = swas_models.DescribeDatabaseSlowLogRecordsRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    start_time='2024-01-01T00:00:00Z',
    end_time='2024-01-02T00:00:00Z',  # 与 start_time 相差不超过 7 天
    page_number=1,
    page_size=30  # 30-100，默认 30
)
resp = client.describe_database_slow_log_records(req)
# 慢日志保留 7 天
```

### describe_database_instance_metric_data - 查询数据库监控

```python
req = swas_models.DescribeDatabaseInstanceMetricDataRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx',
    metric_name='MySQL_MemCpuUsage',  # 可选：MySQL_MemCpuUsage / MySQL_DetailedSpaceUsage 等
    start_time='2024-01-01T00:00:00Z',
    end_time='2024-01-02T00:00:00Z'
)
resp = client.describe_database_instance_metric_data(req)
```
