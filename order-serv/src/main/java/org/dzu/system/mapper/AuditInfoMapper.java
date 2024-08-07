package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.AuditInfo;

import java.util.List;

/**
 * 审核流程Mapper接口
 * 
 * @author ml
 * @date 2024-08-01
 */
public interface AuditInfoMapper extends BaseMapper<AuditInfo>
{
    /**
     * 查询审核流程
     * 
     * @param id 审核流程主键
     * @return 审核流程
     */
    public AuditInfo selectAuditInfoById(Long id);

    /**
     * 查询审核流程列表
     * 
     * @param auditInfo 审核流程
     * @return 审核流程集合
     */
    public List<AuditInfo> selectAuditInfoList(AuditInfo auditInfo);

    /**
     * 新增审核流程
     * 
     * @param auditInfo 审核流程
     * @return 结果
     */
    public int insertAuditInfo(AuditInfo auditInfo);

    /**
     * 修改审核流程
     * 
     * @param auditInfo 审核流程
     * @return 结果
     */
    public int updateAuditInfo(AuditInfo auditInfo);

    /**
     * 删除审核流程
     * 
     * @param id 审核流程主键
     * @return 结果
     */
    public int deleteAuditInfoById(Long id);

    /**
     * 批量删除审核流程
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAuditInfoByIds(Long[] ids);
}
