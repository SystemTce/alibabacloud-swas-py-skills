# 实例与镜像 API 详细参考

## 实例管理

### list_instances - 查询实例列表

```python
req = swas_models.ListInstancesRequest(
    region_id='cn-hangzhou',       # 必填，地域 ID
    instance_ids='["id1","id2"]',  # 可选，JSON 数组，最多 100 个
    instance_name='my-server*',    # 可选，支持通配符 * 模糊搜索
    status='Running',              # 可选：Pending/Starting/Running/Stopping/Stopped/Resetting/Upgrading/Disabled
    charge_type='PrePaid',         # 可选，计费方式，默认 PrePaid
    public_ip_addresses='["1.2.3.4"]',  # 可选，按公网 IP 筛选
    resource_group_id='rg-xxx',    # 可选，资源组 ID
    page_number=1,                 # 可选，页码，默认 1
    page_size=10,                  # 可选，每页条数，最大 100，默认 10
    tag=[swas_models.ListInstancesRequestTag(key='env', value='prod')]  # 可选，标签筛选
)
resp = client.list_instances(req)
```

### list_instance_status - 批量查询实例状态

```python
req = swas_models.ListInstanceStatusRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1","id2"]',  # 可选，JSON 数组，最多 100 个
    page_number=1,
    page_size=10
)
resp = client.list_instance_status(req)
```

### start_instance / start_instances - 启动实例

```python
# 启动单个实例
req = swas_models.StartInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    client_token='uuid-xxx'  # 可选，幂等令牌
)
client.start_instance(req)

# 批量启动
req = swas_models.StartInstancesRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1","id2"]',
    client_token='uuid-xxx'
)
client.start_instances(req)
```

### stop_instance / stop_instances - 停止实例

```python
# 停止单个实例
req = swas_models.StopInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
client.stop_instance(req)

# 批量停止（可强制停止）
req = swas_models.StopInstancesRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1","id2"]',
    force_stop=False  # 可选，是否强制停止
)
client.stop_instances(req)
```

### reboot_instance / reboot_instances - 重启实例

```python
# 重启单个实例（须为 Running 状态）
req = swas_models.RebootInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
client.reboot_instance(req)

# 批量重启
req = swas_models.RebootInstancesRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1","id2"]',
    force_reboot=False  # 可选，是否强制重启
)
client.reboot_instances(req)
```

### update_instance_attribute - 修改实例名称或密码

```python
req = swas_models.UpdateInstanceAttributeRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    instance_name='new-name',  # 可选，2-50 字符，字母或数字开头
    password='NewPass123!'     # 可选，8-30 字符，至少 3 种字符类型
)
client.update_instance_attribute(req)
# 修改密码后需调用 reboot_instance 重启才能生效
```

### upgrade_instance - 升级套餐

```python
# 先查询可升级的套餐
plans_req = swas_models.ListInstancePlansModificationRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
plans_resp = client.list_instance_plans_modification(plans_req)

# 执行升级
req = swas_models.UpgradeInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    plan_id='swas.s1.large'  # 目标套餐 ID
)
client.upgrade_instance(req)
```

### renew_instance - 续费实例

```python
req = swas_models.RenewInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    period=1  # 续费月数：1/3/6/12/24/36
)
client.renew_instance(req)
```

### reset_system - 重置系统

```python
req = swas_models.ResetSystemRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    image_id='img-xxx'  # 可选，不指定则重置当前镜像
)
client.reset_system(req)
# 注意：重置会清除磁盘数据，请提前备份
```

### list_instances_traffic_packages - 查询流量包

```python
req = swas_models.ListInstancesTrafficPackagesRequest(
    region_id='cn-hangzhou',
    instance_ids='["id1"]'  # 必填
)
resp = client.list_instances_traffic_packages(req)
```

### login_instance - 通过 Workbench 登录

```python
req = swas_models.LoginInstanceRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    username='root',       # Linux 可不填，Windows 默认 administrator
    password='xxx',        # Windows 必填
    port=22                # Linux 默认 22，Windows 默认 3389
)
resp = client.login_instance(req)
```

### describe_instance_vnc_url - 获取 VNC 地址

```python
req = swas_models.DescribeInstanceVncUrlRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
resp = client.describe_instance_vnc_url(req)
```

### modify_instance_vnc_password - 修改 VNC 密码

```python
req = swas_models.ModifyInstanceVncPasswordRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    vnc_password='newVncPwd'
)
client.modify_instance_vnc_password(req)
```

### describe_instance_passwords_setting - 查询密码设置状态

```python
req = swas_models.DescribeInstancePasswordsSettingRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
resp = client.describe_instance_passwords_setting(req)
```

### start_terminal_session - 创建终端会话

```python
req = swas_models.StartTerminalSessionRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx'
)
resp = client.start_terminal_session(req)
```

---

## 镜像管理

### list_images - 查询镜像列表

```python
req = swas_models.ListImagesRequest(
    region_id='cn-hangzhou',
    image_type='system',   # 可选：system/app/custom
    image_ids='["img1"]'   # 可选，JSON 数组，最多 50 个
)
resp = client.list_images(req)
```

### list_custom_images - 查询自定义镜像

```python
req = swas_models.ListCustomImagesRequest(
    region_id='cn-hangzhou',
    image_ids='["img1"]',          # 可选，JSON 数组，最多 100 个
    image_names='["my-image"]',    # 可选，JSON 数组
    instance_id='ace57xxx',        # 可选，按来源实例筛选
    system_snapshot_id='sp-xxx',   # 可选，按系统盘快照筛选
    data_snapshot_id='sp-xxx',     # 可选，按数据盘快照筛选
    resource_group_id='rg-xxx',    # 可选
    share=False,                   # 可选，是否查询共享镜像
    page_number=1,
    page_size=10,
    tag=[swas_models.ListCustomImagesRequestTag(key='env', value='prod')]
)
resp = client.list_custom_images(req)
```

### create_custom_image - 创建自定义镜像

```python
req = swas_models.CreateCustomImageRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',        # 必填，来源实例 ID
    image_name='my-custom-image',  # 必填，镜像名称
    description='备份镜像',         # 可选
    system_snapshot_id='sp-xxx',   # 可选，系统盘快照 ID
    data_snapshot_id='sp-xxx',     # 可选，数据盘快照 ID
    resource_group_id='rg-xxx',    # 可选
    tag=[swas_models.CreateCustomImageRequestTag(key='env', value='prod')]
)
resp = client.create_custom_image(req)
print(f"镜像 ID: {resp.body.image_id}")
```

### delete_custom_image - 删除自定义镜像

```python
req = swas_models.DeleteCustomImageRequest(
    region_id='cn-hangzhou',
    image_id='img-xxx'
)
client.delete_custom_image(req)
```

### modify_image_share_status - 共享/取消共享镜像到 ECS

```python
req = swas_models.ModifyImageShareStatusRequest(
    region_id='cn-hangzhou',
    image_id='img-xxx',
    operation='Share'  # Share 或 UnShare
)
client.modify_image_share_status(req)
```

### add_custom_image_share_account - 跨账号共享镜像

```python
req = swas_models.AddCustomImageShareAccountRequest(
    region_id='cn-hangzhou',
    image_id='img-xxx',
    account=[123456789]  # 目标阿里云账号 ID 列表
)
client.add_custom_image_share_account(req)
# 注意：共享前需确保镜像中已删除敏感数据和文件
```

### remove_custom_image_share_account - 取消跨账号共享

```python
req = swas_models.RemoveCustomImageShareAccountRequest(
    region_id='cn-hangzhou',
    image_id='img-xxx',
    account=[123456789]
)
client.remove_custom_image_share_account(req)
```

### list_custom_image_share_accounts - 查询镜像共享账号

```python
req = swas_models.ListCustomImageShareAccountsRequest(
    region_id='cn-hangzhou',
    image_id='img-xxx',
    page_number=1,
    page_size=10
)
resp = client.list_custom_image_share_accounts(req)
```

---

## 地域与套餐

### list_regions - 查询支持的地域

```python
req = swas_models.ListRegionsRequest(
    accept_language='zh-CN'  # zh-CN（中文）或 en-US（英文）
)
resp = client.list_regions(req)
```

### list_plans - 查询套餐列表

```python
req = swas_models.ListPlansRequest(
    region_id='cn-hangzhou'
)
resp = client.list_plans(req)
```
