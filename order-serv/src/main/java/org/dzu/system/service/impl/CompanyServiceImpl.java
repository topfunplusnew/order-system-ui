package org.dzu.system.service.impl;

import java.util.List;

import org.dzu.common.constant.CompanyConstant;
import org.dzu.common.core.domain.entity.SysUser;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.CompanyMapper;
import org.dzu.system.domain.Company;
import org.dzu.system.service.ICompanyService;

/**
 * 客户管理Service业务层处理
 * 
 * @author ml
 * @date 2024-07-19
 */
@Service
public class CompanyServiceImpl implements ICompanyService 
{
    @Autowired
    private CompanyMapper companyMapper;

    /**
     * 查询客户管理
     * 
     * @param id 客户管理主键
     * @return 客户管理
     */
    @Override
    public Company selectCompanyById(Long id)
    {
        return companyMapper.selectCompanyById(id);
    }

    /**
     * 查询客户管理列表
     * 
     * @param company 客户管理
     * @return 客户管理
     */
    @Override
    public List<Company> selectCompanyList(Company company)
    {
        return companyMapper.selectCompanyList(company);
    }


    /**
     * 新增客户管理
     * 
     * @param company 客户管理
     * @return 结果
     */
    @Override
    public int insertCompany(Company company){
        // 设置基础属性
        company.setDelFlag(Long.valueOf(CompanyConstant.NODEL));
        company.setAddtime(DateUtils.getTime());
        updateModifypersonneldata(company);
        return companyMapper.insertCompany(company);
    }


    /**
     * 修改客户管理
     * 
     * @param company 客户管理
     * @return 结果
     */
    @Override
    public int updateCompany(Company company)
    {
        updateModifypersonneldata(company);
        company.setUpdateTime(DateUtils.getNowDate());
        return companyMapper.updateCompany(company);
    }

    /**
     * 批量删除客户管理
     * 
     * @param ids 需要删除的客户管理主键
     * @return 结果
     */
    @Override
    public int deleteCompanyByIds(Long[] ids)
    {
        return companyMapper.deleteCompanyByIds(ids);
    }

    /**
     * 删除客户管理信息
     * 
     * @param id 客户管理主键
     * @return 结果
     */
    @Override
    public int deleteCompanyById(Long id)
    {
        return companyMapper.deleteCompanyById(id);
    }

    private void updateModifypersonneldata(Company company){
        // 设置操作人员+添加时间
        SysUser user = SecurityUtils.getLoginUser().getUser();
        company.setUserId(user.getUserId());
        company.setUserName(user.getTrueName());
    }
}
