# 回滚操作检查清单

**项目**: ****\_\_\_****  
**版本**: 从 v**\_** 回滚到 v**\_**  
**执行人**: @**\_\_\_**  
**时间**: 2026-01-23 **:**

---

## 回滚前确认

- [ ] 已确认回滚目标版本（最后稳定版本号）
- [ ] 已确认回滚原因和影响范围
- [ ] 已通知相关人员（团队/用户）
- [ ] 已准备好应急沟通渠道
- [ ] 已指定事件指挥官（IC）

---

## 数据备份

- [ ] 备份当前数据库快照
  ```bash
  mysqldump -u root -p mydb > backup_$(date +%Y%m%d_%H%M%S).sql
  ```
- [ ] 备份关键配置文件
  ```bash
  tar -czf config_backup_$(date +%Y%m%d_%H%M%S).tar.gz /etc/myapp/
  ```
- [ ] 确认备份文件完整性
  ```bash
  md5sum backup_*.sql > backup.md5
  ```

---

## 应用层回滚

### Kubernetes

- [ ] 检查部署历史
  ```bash
  kubectl rollout history deployment/myapp -n production
  ```
- [ ] 执行回滚
  ```bash
  kubectl rollout undo deployment/myapp -n production --to-revision=X
  ```
- [ ] 监控回滚进度
  ```bash
  kubectl rollout status deployment/myapp -n production
  ```
- [ ] 验证 Pod 状态
  ```bash
  kubectl get pods -n production -l app=myapp
  ```

### Docker

- [ ] 停止当前容器
  ```bash
  docker-compose down
  ```
- [ ] 切换镜像版本
  ```bash
  docker-compose pull myapp:v2.3.1
  ```
- [ ] 启动回滚版本
  ```bash
  docker-compose up -d
  ```

### 传统部署

- [ ] 停止服务
  ```bash
  systemctl stop myapp
  ```
- [ ] 回滚代码
  ```bash
  cd /opt/myapp
  git checkout tags/v2.3.1
  ```
- [ ] 恢复依赖
  ```bash
  npm ci  # 或 pip install -r requirements.txt
  ```
- [ ] 启动服务
  ```bash
  systemctl start myapp
  ```

---

## 数据库回滚（如需要）

⚠️ **高风险操作，务必谨慎！**

- [ ] 确认数据库变更内容
- [ ] 准备回滚 SQL 脚本
- [ ] 在测试环境验证回滚脚本
- [ ] 通知 DBA 执行
- [ ] 执行前再次备份
  ```bash
  mysqldump -u root -p mydb > pre_rollback_backup.sql
  ```
- [ ] 执行回滚脚本
  ```bash
  mysql -u root -p mydb < rollback.sql
  ```
- [ ] 验证数据一致性

---

## 配置回滚

- [ ] 恢复环境变量
  ```bash
  cp /backup/env.production .env.production
  ```
- [ ] 恢复 Nginx/负载均衡器配置
  ```bash
  cp /backup/nginx.conf /etc/nginx/nginx.conf
  nginx -t && nginx -s reload
  ```
- [ ] 恢复其他配置文件

---

## 验证检查

### 基础检查

- [ ] 服务启动成功
  ```bash
  systemctl status myapp
  # 或
  kubectl get pods -n production
  ```
- [ ] 健康检查通过
  ```bash
  curl https://api.example.com/health
  ```
- [ ] 日志无异常错误
  ```bash
  tail -f /var/log/myapp/app.log
  ```

### 功能验证

- [ ] 核心接口可访问
  - [ ] 登录: `curl -X POST https://api.example.com/login`
  - [ ] 查询: `curl https://api.example.com/users/me`
  - [ ] 创建: `curl -X POST https://api.example.com/orders`
- [ ] 数据库连接正常
  ```bash
  mysql -e "SELECT 1"
  ```
- [ ] 第三方依赖连接正常
  ```bash
  curl https://api.third-party.com/health
  ```

### 性能验证

- [ ] 响应时间正常（< 200ms）
- [ ] CPU 使用率正常（< 70%）
- [ ] 内存使用正常（无泄漏）
- [ ] 数据库连接数正常

---

## 监控验证

- [ ] 检查 Grafana 面板
  - [ ] 请求成功率 > 99.5%
  - [ ] P95 延迟 < 500ms
  - [ ] 错误率 < 0.5%
- [ ] 检查日志聚合（ELK/Loki）
  - [ ] ERROR 日志正常
  - [ ] 无堆栈异常
- [ ] 检查 APM（Sentry/NewRelic）
  - [ ] 无新增异常
  - [ ] 事务成功率正常

---

## 流量验证

- [ ] 小流量验证（金丝雀）
  ```bash
  # 切 5% 流量到回滚版本
  kubectl patch deployment myapp -p '{"spec":{"strategy":{"rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
  ```
- [ ] 观察 10-15 分钟
- [ ] 逐步放量（20% → 50% → 100%）
- [ ] 全量验证

---

## 清理工作

- [ ] 清理失败的 Pod/容器
  ```bash
  kubectl delete pod <failed-pod> -n production
  docker system prune -f
  ```
- [ ] 标记问题版本
  ```bash
  git tag -a v2.4.0-FAILED -m "回滚原因：数据库连接配置错误"
  ```
- [ ] 更新部署文档
- [ ] 记录回滚操作到 Wiki

---

## 沟通更新

- [ ] 发送回滚完成通知

  ```
  ✅ 回滚完成

  版本：v2.4.0 → v2.3.1
  时间：2026-01-23 15:10
  验证：所有检查通过

  下一步：18:00 Postmortem 会议
  ```

- [ ] 更新状态页面
- [ ] 通知客户（如需要）

---

## 事后跟进

- [ ] 安排 Postmortem 会议（24小时内）
- [ ] 完成故障报告（参见 `incident-report.md`）
- [ ] 制定预防措施
- [ ] 更新 Runbook 文档

---

## 紧急联系

| 角色       | 姓名 | 电话          | Slack     |
| ---------- | ---- | ------------- | --------- |
| 技术负责人 | 张三 | 138-xxxx-xxxx | @zhangsan |
| DBA        | 李四 | 139-xxxx-xxxx | @lisi     |
| 运维负责人 | 王五 | 137-xxxx-xxxx | @wangwu   |
| 产品经理   | 赵六 | 136-xxxx-xxxx | @zhaoliu  |

---

**执行确认**

- [ ] 所有步骤已完成
- [ ] 所有验证已通过
- [ ] 已通知相关人员
- [ ] 已记录操作日志

**执行人签名**: **\_\_\_\_**  
**复核人签名**: **\_\_\_\_**  
**完成时间**: 2026-01-23 **:**
