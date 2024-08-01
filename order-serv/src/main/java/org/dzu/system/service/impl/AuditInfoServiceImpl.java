package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.AuditInfoMapper;
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.service.IAuditInfoService;
/**
 * 审核流程Service业务层处理
 *
 * @author ml
 * @date 2024-08-01
 */
@Service
public class AuditInfoServiceImpl implements IAuditInfoService
{
    @Autowired
    private AuditInfoMapper auditInfoMapper;

    /**
     * 查询审核流程
     *
     * @param id 审核流程主键
     * @return 审核流程
     */
    @Override
    public AuditInfo selectAuditInfoById(Long id)
    {
        return auditInfoMapper.selectAuditInfoById(id);
    }

    /**
     * 查询审核流程列表
     *
     * @param auditInfo 审核流程
     * @return 审核流程
     */
    @Override
    public List<AuditInfo> selectAuditInfoList(AuditInfo auditInfo)
    {
        return auditInfoMapper.selectAuditInfoList(auditInfo);
    }

    /**
     * 新增审核流程
     *
     * @param auditInfo 审核流程
     * @return 结果
     */
    @Override
    public int insertAuditInfo(AuditInfo auditInfo)
    {
        auditInfo.setUserId(SecurityUtils.getUserId());
        auditInfo.setUserName(SecurityUtils.getUserTruename());
        return auditInfoMapper.insertAuditInfo(auditInfo);
    }

    /**
     * 修改审核流程
     * 
     * @param auditInfo 审核流程
     * @return 结果
     */
    @Override
    public int updateAuditInfo(AuditInfo auditInfo)
    {
        auditInfo.setUserId(SecurityUtils.getUserId());
        auditInfo.setUserName(SecurityUtils.getUserTruename());
        return auditInfoMapper.updateAuditInfo(auditInfo);
    }

    /**
     * 批量删除审核流程
     * 
     * @param ids 需要删除的审核流程主键
     * @return 结果
     */
    @Override
    public int deleteAuditInfoByIds(Long[] ids)
    {
        return auditInfoMapper.deleteAuditInfoByIds(ids);
    }

    /**
     * 删除审核流程信息
     * 
     * @param id 审核流程主键
     * @return 结果
     */
    @Override
    public int deleteAuditInfoById(Long id)
    {
        return auditInfoMapper.deleteAuditInfoById(id);
    }
}
