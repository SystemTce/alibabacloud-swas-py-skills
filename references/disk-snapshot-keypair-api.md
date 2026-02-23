# 磁盘、快照、密钥对与其他 API 详细参考

## 磁盘管理

### list_disks - 查询磁盘列表

```python
req = swas_models.ListDisksRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',       # 可选，按实例筛选
    disk_ids='["d-id1","d-id2"]', # 可选，JSON 数组，最多 100 个
    disk_type='system',           # 可选：system / data，不填查两种
    resource_group_id='rg-xxx',   # 可选
    page_number=1,
    page_size=10,
    tag=[swas_models.ListDisksRequestTag(key='env', value='prod')]
)
resp = client.list_disks(req)
# instance_id、disk_ids、resource_group_id 可组合使用（AND 逻辑）
```

### update_disk_attribute - 修改磁盘备注

```python
req = swas_models.UpdateDiskAttributeRequest(
    region_id='cn-hangzhou',
    disk_id='d-xxx',      # 必填
    remark='数据盘-业务A'   # 必填
)
client.update_disk_attribute(req)
```

### reset_disk - 通过快照回滚磁盘

```python
req = swas_models.ResetDiskRequest(
    region_id='cn-hangzhou',
    disk_id='d-xxx',       # 必填
    snapshot_id='sp-xxx'   # 必填
)
client.reset_disk(req)
# 注意：
# 1. 实例须为 Stopped 状态
# 2. 回滚后快照之后的增量数据将丢失
# 3. 重置系统或更换镜像后，之前的快照仍保留但无法用于回滚
```

---

## 快照管理

### list_snapshots - 查询快照列表

```python
req = swas_models.ListSnapshotsRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',         # 可选
    disk_id='d-xxx',                # 可选
    snapshot_ids='["sp-id1"]',      # 可选，JSON 数组，最多 100 个
    source_disk_type='system',      # 可选：system / data
    resource_group_id='rg-xxx',     # 可选
    page_number=1,
    page_size=10,
    tag=[swas_models.ListSnapshotsRequestTag(key='env', value='prod')]
)
resp = client.list_snapshots(req)
# instance_id、disk_id、snapshot_ids、resource_group_id 可组合使用（AND 逻辑）
```

### create_snapshot - 创建快照

```python
req = swas_models.CreateSnapshotRequest(
    region_id='cn-hangzhou',
    disk_id='d-xxx',                  # 必填
    snapshot_name='daily-backup',     # 必填
    resource_group_id='rg-xxx',       # 可选
    tag=[swas_models.CreateSnapshotRequestTag(key='type', value='backup')]
)
resp = client.create_snapshot(req)
print(f"快照 ID: {resp.body.snapshot_id}")
```

### delete_snapshot - 删除单个快照

```python
req = swas_models.DeleteSnapshotRequest(
    region_id='cn-hangzhou',
    snapshot_id='sp-xxx'
)
client.delete_snapshot(req)
# 如果快照已创建自定义镜像，需先删除镜像再删除快照
```

### delete_snapshots - 批量删除快照

```python
req = swas_models.DeleteSnapshotsRequest(
    region_id='cn-hangzhou',
    snapshot_ids='["sp-id1","sp-id2"]'  # 必填，JSON 数组
)
client.delete_snapshots(req)
```

### update_snapshot_attribute - 修改快照备注

```python
req = swas_models.UpdateSnapshotAttributeRequest(
    region_id='cn-hangzhou',
    snapshot_id='sp-xxx',
    remark='周末完整备份'
)
client.update_snapshot_attribute(req)
```

---

## 密钥对管理

### list_key_pairs - 查询密钥对列表

```python
req = swas_models.ListKeyPairsRequest(
    region_id='cn-hangzhou',
    key_pair_name='my-key',  # 可选，2-64 字符
    page_number=1,
    page_size=10
)
resp = client.list_key_pairs(req)
```

### create_key_pair - 创建密钥对

```python
req = swas_models.CreateKeyPairRequest(
    region_id='cn-hangzhou',
    key_pair_name='my-new-key'  # 必填
)
resp = client.create_key_pair(req)
# 创建后会返回私钥，请妥善保存，不会再次提供
```

### import_key_pair - 导入已有密钥对

```python
req = swas_models.ImportKeyPairRequest(
    region_id='cn-hangzhou',
    key_pair_name='my-imported-key',  # 必填，2-64 字符
    public_key_body='ssh-rsa AAAA...'  # 必填，公钥内容
)
client.import_key_pair(req)
```

### attach_key_pair - 绑定密钥对到实例

```python
req = swas_models.AttachKeyPairRequest(
    region_id='cn-hangzhou',
    key_pair_name='my-key',                # 必填
    instance_ids='["id1","id2"]'           # 必填，JSON 数组，最多 50 个
)
client.attach_key_pair(req)
```

### detach_key_pair - 解绑密钥对

```python
req = swas_models.DetachKeyPairRequest(
    region_id='cn-hangzhou',
    key_pair_name='my-key',         # 必填，2-64 字符
    instance_ids=['id1', 'id2']     # 必填，最多 50 个
)
client.detach_key_pair(req)
```

### delete_key_pairs - 删除密钥对

```python
req = swas_models.DeleteKeyPairsRequest(
    region_id='cn-hangzhou',
    key_pair_names='["key1","key2"]'  # 必填，JSON 数组
)
client.delete_key_pairs(req)
# 删除前须先解绑
```

### upload_instance_key_pair - 为实例上传密钥对

```python
req = swas_models.UploadInstanceKeyPairRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    key_pair_name='instance-key',
    public_key='ssh-rsa AAAA...'
)
client.upload_instance_key_pair(req)
```

### describe_instance_key_pair - 查询实例密钥对信息

```python
req = swas_models.DescribeInstanceKeyPairRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
resp = client.describe_instance_key_pair(req)
```

### delete_instance_key_pair - 删除实例密钥对

```python
req = swas_models.DeleteInstanceKeyPairRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
client.delete_instance_key_pair(req)
```

---

## 监控数据

### describe_monitor_data - 查询实例监控数据

```python
req = swas_models.DescribeMonitorDataRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',         # 必填
    metric_name='CPU_UTILIZATION',  # 可选：CPU_UTILIZATION / MEMORY_ACTUALUSEDSPACE / DISKUSAGE_USED 等
    start_time='1704067200000',     # 可选，UNIX 时间戳（毫秒）或 ISO 8601
    end_time='1704153600000',       # 可选
    period='300',                   # 可选，查询间隔（秒）：60/300/900，流量用 3600
    length='100',                   # 可选，每页条数 1-1440
    next_token='xxx'                # 可选，翻页标记
)
resp = client.describe_monitor_data(req)
```

**可用监控指标：**
| 指标名 | 说明 |
|--------|------|
| `CPU_UTILIZATION` | CPU 利用率 |
| `MEMORY_ACTUALUSEDSPACE` | 实际内存使用量 |
| `DISKUSAGE_USED` | 磁盘使用量 |
| `FLOW_USED` | 流量使用量（period 需用 3600） |

### install_cloud_monitor_agent - 安装云监控插件

```python
req = swas_models.InstallCloudMonitorAgentRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    force=True  # 可选，是否强制安装，默认 True
)
client.install_cloud_monitor_agent(req)
```

### describe_cloud_monitor_agent_statuses - 查询云监控插件状态

```python
req = swas_models.DescribeCloudMonitorAgentStatusesRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1","id2"]'  # 必填
)
resp = client.describe_cloud_monitor_agent_statuses(req)
```

### describe_security_agent_status - 查询安全中心 Agent 状态

```python
req = swas_models.DescribeSecurityAgentStatusRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
resp = client.describe_security_agent_status(req)
```

---

## 标签管理

### tag_resources - 为资源添加标签

```python
req = swas_models.TagResourcesRequest(
    region_id='cn-hangzhou',
    resource_type='instance',  # 必填：instance/snapshot/customimage/command/firewallrule/disk
    resource_id=['id1', 'id2'],  # 必填，最多 50 个
    tag=[
        swas_models.TagResourcesRequestTag(key='env', value='prod'),
        swas_models.TagResourcesRequestTag(key='team', value='backend')
    ]  # 必填，最多 20 个标签
)
client.tag_resources(req)
```

### untag_resources - 移除资源标签

```python
req = swas_models.UntagResourcesRequest(
    region_id='cn-hangzhou',
    resource_type='instance',
    resource_id=['id1', 'id2'],  # 必填，最多 50 个
    tag_key=['env', 'team'],     # 可选，要移除的标签 Key，最多 20 个
    all=False                    # 可选，是否移除所有标签（tag_key 未设置时生效）
)
client.untag_resources(req)
```

### list_tag_resources - 查询资源标签

```python
req = swas_models.ListTagResourcesRequest(
    region_id='cn-hangzhou',
    resource_type='instance',       # 必填
    resource_id=['id1', 'id2'],     # 可选，最多 50 个
    tag=[
        swas_models.ListTagResourcesRequestTag(key='env', value='prod')
    ],                              # 可选，按标签筛选
    next_token='xxx'                # 可选，翻页标记
)
resp = client.list_tag_resources(req)
```
