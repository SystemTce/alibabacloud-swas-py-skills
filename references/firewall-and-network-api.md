# 防火墙与网络 API 详细参考

## 防火墙规则管理

### list_firewall_rules - 查询防火墙规则

```python
req = swas_models.ListFirewallRulesRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',         # 必填
    firewall_rule_id='rule-xxx',    # 可选，按规则 ID 筛选
    page_number=1,
    page_size=10,
    tag=[swas_models.ListFirewallRulesRequestTag(key='env', value='prod')]
)
resp = client.list_firewall_rules(req)
```

### create_firewall_rule - 创建单条防火墙规则

```python
req = swas_models.CreateFirewallRuleRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',    # 必填
    port='443/443',            # 必填，端口范围（如 80/80 或 1024/1055）
    rule_protocol='TCP',       # 必填：TCP / UDP / TCP+UDP
    remark='HTTPS',            # 可选，备注
    source_cidr_ip='0.0.0.0/0' # 可选，允许的 IP/CIDR
)
resp = client.create_firewall_rule(req)
print(f"防火墙规则 ID: {resp.body.firewall_id}")
```

### create_firewall_rules - 批量创建防火墙规则

```python
rules = [
    swas_models.CreateFirewallRulesRequestFirewallRules(
        port='80/80',
        rule_protocol='TCP',
        remark='HTTP',
        source_cidr_ip='0.0.0.0/0'
    ),
    swas_models.CreateFirewallRulesRequestFirewallRules(
        port='443/443',
        rule_protocol='TCP',
        remark='HTTPS',
        source_cidr_ip='0.0.0.0/0'
    )
]
req = swas_models.CreateFirewallRulesRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    firewall_rules=rules
)
resp = client.create_firewall_rules(req)
```

### delete_firewall_rules - 批量删除防火墙规则

```python
req = swas_models.DeleteFirewallRulesRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    rule_ids=['rule-id1', 'rule-id2']  # 必填，规则 ID 列表
)
client.delete_firewall_rules(req)
```

### modify_firewall_rule - 修改防火墙规则

```python
req = swas_models.ModifyFirewallRuleRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',     # 必填
    rule_id='rule-xxx',         # 必填
    port='8080/8080',           # 必填
    rule_protocol='TCP',        # 必填：TCP / UDP / TCP+UDP
    remark='Custom Port',       # 可选
    source_cidr_ip='10.0.0.0/8' # 可选
)
client.modify_firewall_rule(req)
```

### enable_firewall_rule - 启用防火墙规则

```python
req = swas_models.EnableFirewallRuleRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    rule_id='rule-xxx',
    remark='启用规则',           # 可选
    source_cidr_ip='0.0.0.0/0'  # 可选
)
client.enable_firewall_rule(req)
```

### disable_firewall_rule - 禁用防火墙规则

```python
req = swas_models.DisableFirewallRuleRequest(
    region_id='cn-hangzhou',
    instance_id='ace57xxx',
    rule_id='rule-xxx',
    remark='临时禁用'  # 可选
)
client.disable_firewall_rule(req)
```

---

## 防火墙模板管理

### create_firewall_template - 创建防火墙模板

```python
rules = [
    swas_models.CreateFirewallTemplateRequestFirewallTemplateRule(
        port='22/22',
        rule_protocol='TCP',
        remark='SSH',
        source_cidr_ip='0.0.0.0/0'
    ),
    swas_models.CreateFirewallTemplateRequestFirewallTemplateRule(
        port='80/80',
        rule_protocol='TCP',
        remark='HTTP',
        source_cidr_ip='0.0.0.0/0'
    )
]
req = swas_models.CreateFirewallTemplateRequest(
    region_id='cn-hangzhou',
    name='web-server-template',      # 必填
    description='Web 服务器防火墙模板',  # 可选
    firewall_template_rule=rules     # 必填
)
resp = client.create_firewall_template(req)
print(f"模板 ID: {resp.body.firewall_template_id}")
```

### describe_firewall_templates - 查询防火墙模板

```python
req = swas_models.DescribeFirewallTemplatesRequest(
    region_id='cn-hangzhou',
    firewall_template_id=['ft-xxx'],  # 可选，模板 ID 列表
    name='web',                        # 可选，模板名称
    page_number=1,
    page_size=20
)
resp = client.describe_firewall_templates(req)
```

### modify_firewall_template - 修改防火墙模板

```python
req = swas_models.ModifyFirewallTemplateRequest(
    region_id='cn-hangzhou',
    firewall_template_id='ft-xxx',  # 必填
    name='new-name',                # 可选
    description='new desc',         # 可选
    firewall_template_rule=[...]    # 可选，新的规则列表
)
client.modify_firewall_template(req)
# 注意：修改模板不会影响已应用的防火墙规则
```

### delete_firewall_template - 删除防火墙模板

```python
req = swas_models.DeleteFirewallTemplateRequest(
    region_id='cn-hangzhou',
    firewall_template_id='ft-xxx',
    instance_id='ace57xxx'  # 可选
)
client.delete_firewall_template(req)
```

### apply_firewall_template - 应用防火墙模板

```python
req = swas_models.ApplyFirewallTemplateRequest(
    region_id='cn-hangzhou',
    firewall_template_id='ft-xxx',  # 必填
    instance_id='ace57xxx'          # 必填
)
resp = client.apply_firewall_template(req)
print(f"任务 ID: {resp.body.task_id}")
```

### describe_firewall_template_apply_results - 查询模板应用结果

```python
req = swas_models.DescribeFirewallTemplateApplyResultsRequest(
    region_id='cn-hangzhou',
    firewall_template_id='ft-xxx',
    task_id=['task-xxx'],  # 可选
    page_number=1,
    page_size=20
)
resp = client.describe_firewall_template_apply_results(req)
```

### describe_firewall_template_rules_apply_result - 查询规则应用结果

```python
req = swas_models.DescribeFirewallTemplateRulesApplyResultRequest(
    region_id='cn-hangzhou',
    firewall_template_id='ft-xxx',  # 必填
    instance_id='ace57xxx',          # 必填
    task_id='task-xxx'               # 必填
)
resp = client.describe_firewall_template_rules_apply_result(req)
```

---

## 数据库公网连接

### allocate_public_connection - 申请数据库公网地址

```python
req = swas_models.AllocatePublicConnectionRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'
)
client.allocate_public_connection(req)
# 默认不分配公网地址，需要通过外网访问数据库时使用此接口
```

### release_public_connection - 释放数据库公网地址

```python
req = swas_models.ReleasePublicConnectionRequest(
    region_id='cn-hangzhou',
    database_instance_id='db-xxx'
)
client.release_public_connection(req)
```
