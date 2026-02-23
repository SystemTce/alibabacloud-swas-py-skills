# Alibaba Cloud SWAS Python SDK Skills

阿里云轻量应用服务器 (Simple Application Server / SWAS) Python SDK 调用指南 - Claude Code 技能库

## 简介

本项目是一个专为 Claude Code 设计的技能库，用于帮助开发者方便地使用阿里云轻量应用服务器的 Python SDK 进行服务器管理。

通过此技能库，AI 助手可以正确地使用阿里云 SWAS SDK 调用各种 API，包括：

- **实例管理**：创建、启动、停止、重启、升级、续费服务器
- **镜像管理**：自定义镜像创建、删除、共享
- **快照与磁盘管理**：创建快照、回滚磁盘
- **防火墙配置**：配置防火墙规则、创建和应用模板
- **云助手**：远程执行命令、查询执行结果
- **密钥对管理**：SSH 密钥对创建、导入、绑定
- **轻量数据库**：管理 Simple Database Service 实例
- **监控查询**：查询 CPU、内存、磁盘、流量等监控数据
- **标签管理**：为资源添加和管理标签

## 目录结构

```
alibabacloud-swas/
├── SKILL.md                        # 技能定义文件
├── README.md                       # 本说明文件
└── references/                     # API 参考文档
    ├── instance-and-image-api.md   # 实例与镜像 API
    ├── firewall-and-network-api.md # 防火墙与网络 API
    ├── command-and-database-api.md # 命令与数据库 API
    └── disk-snapshot-keypair-api.md# 磁盘、快照、密钥对 API
```

## 安装

```bash
pip install alibabacloud_swas_open20200601
```

## 快速开始

```python
from alibabacloud_tea_openapi import models as open_api_models
from alibabacloud_swas_open20200601.client import Client
from alibabacloud_swas_open20200601 import models as swas_models

# 初始化客户端
config = open_api_models.Config(
    access_key_id='your-access-key-id',
    access_key_secret='your-access-key-secret',
    region_id='cn-hangzhou'
)
client = Client(config)

# 查询实例列表
request = swas_models.ListInstancesRequest(
    region_id='cn-hangzhou',
    page_number=1,
    page_size=10
)
response = client.list_instances(request)

for inst in response.body.instances:
    print(f"ID: {inst.instance_id}, Name: {inst.instance_name}, IP: {inst.public_ip_address}")
```

## 使用此技能

如果你使用 Claude Code，可以将此技能目录添加到 `~/.claude/skills/` 目录下：

```bash
git clone https://github.com/YOUR_USERNAME/alibabacloud-swas-py-skills.git
cp -r alibabacloud-swas-py-skills/alibabacloud-swas ~/.claude/skills/
```

然后在需要管理阿里云轻量应用服务器时，Claude 会自动使用此技能。

## API 分类

| 分类 | API 数量 | 主要功能 |
|------|---------|---------|
| 实例生命周期管理 | ~15 | 创建、启停、重启、升级、续费 |
| 镜像管理 | ~8 | 自定义镜像创建、删除、共享 |
| 磁盘与快照管理 | ~7 | 磁盘管理、快照创建与回滚 |
| 防火墙管理 | ~14 | 规则配置、模板管理 |
| 命令与云助手 | ~10 | 远程命令执行 |
| 密钥对管理 | ~8 | SSH 密钥对管理 |
| 轻量数据库管理 | ~13 | 数据库实例管理 |
| 监控与安全 | ~8 | 监控数据查询、安全状态 |
| 标签管理 | ~3 | 资源标签管理 |
| 地域与套餐 | ~2 | 查询支持的地域和套餐 |

## 注意事项

1. **AccessKey 安全**：不要将 AccessKey 硬编码在代码中，建议使用环境变量或配置文件
2. **地域 ID**：几乎所有接口都需要指定 `region_id` 参数
3. **幂等性**：写操作建议传入 `client_token` 参数，防止重复操作
4. **批量参数**：批量操作的 ID 参数通常需要 JSON 数组字符串格式

## 相关资源

- [阿里云 SWAS 官方文档](https://api.aliyun.com/api/SWAS-OPEN/2020-06-01/CreateInstances)
- [Python SDK GitHub 仓库](https://github.com/aliyun/alibabacloud-python-sdk/tree/master/swas-open-20200601)

## 许可证

MIT License
