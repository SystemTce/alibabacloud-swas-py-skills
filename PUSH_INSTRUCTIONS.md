# 推送到 GitHub 的步骤

## 方案一：通过 GitHub 网页创建（推荐）

### 第 1 步：在 GitHub 上创建仓库

1. 访问 https://github.com/new
2. 仓库名称：`alibabacloud-swas-py-skills`
3. 可见性：**Public（公开）**
4. **不要**勾选 "Initialize this repository with a README"
5. 点击 "Create repository"

### 第 2 步：推送代码

创建仓库后，GitHub 会显示推送指令，执行以下命令：

```bash
cd /tmp/alibabacloud-swas-py-skills
git branch -M main
git remote set-url origin https://github.com/SystemTce/alibabacloud-swas-py-skills.git
git push -u origin main
```

如果提示输入用户名和密码：
- Username: `SystemTce`
- Password: 使用你的 **Personal Access Token**（不是 GitHub 登录密码）

---

## 方案二：使用 gh CLI（需要先安装）

### 安装 gh CLI

```bash
# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

# 或者使用 snap
sudo snap install gh --classic
```

### 登录并创建仓库

```bash
gh auth login
# 按提示完成登录

cd /tmp/alibabacloud-swas-py-skills
gh repo create alibabacloud-swas-py-skills --public --push
```

---

## 完成后的仓库结构

```
alibabacloud-swas-py-skills/
├── .gitignore
├── README.md
├── SKILL.md
└── references/
    ├── command-and-database-api.md
    ├── disk-snapshot-keypair-api.md
    ├── firewall-and-network-api.md
    └── instance-and-image-api.md
```

---

## 验证

推送完成后，访问 https://github.com/SystemTce/alibabacloud-swas-py-skills 查看你的仓库！
