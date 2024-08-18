package org.dzu.system.service.impl;

import org.dzu.common.constant.DelConstants;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.Company;
import org.dzu.system.mapper.CompanyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 客户、供应商信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class CompanyServiceImpl {
    @Autowired
    private CompanyMapper companyMapper;

    /**
     * 查询客户、供应商信息
     *
     * @param id 客户、供应商信息主键
     * @return 客户、供应商信息
     */
    public Company selectCompanyById(Long id)
    {
        return companyMapper.selectCompanyById(id);
    }

    /**
     * 查询客户、供应商信息列表
     *
     * @param company 客户、供应商信息
     * @return 客户、供应商信息
     */
    public List<Company> selectCompanyList(Company company)
    {
        return companyMapper.selectCompanyList(company);
    }

    /**
     * 新增客户、供应商信息
     *
     * @param company 客户、供应商信息
     * @return 结果
     */
    public int insertCompany(Company company)
    {
        company.setAddtime(String.valueOf(DateUtils.getNowDate()));
        company.setUserId(SecurityUtils.getUserId());
        company.setUserName(SecurityUtils.getUserTruename());
        company.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return companyMapper.insertCompany(company);
    }

    /**
     * 修改客户、供应商信息
     * 
     * @param company 客户、供应商信息
     * @return 结果
     */
    public int updateCompany(Company company)
    {
        company.setUserId(SecurityUtils.getUserId());
        company.setUserName(SecurityUtils.getUserTruename());
        company.setUpdateTime(DateUtils.getNowDate());
        return companyMapper.updateCompany(company);
    }

    /**
     * 批量删除客户、供应商信息
     * 
     * @param ids 需要删除的客户、供应商信息主键
     * @return 结果
     */
    public int deleteCompanyByIds(Long[] ids)
    {
        return companyMapper.deleteCompanyByIds(ids);
    }

    /**
     * 删除客户、供应商信息信息
     * 
     * @param id 客户、供应商信息主键
     * @return 结果
     */
    public int deleteCompanyById(Long id)
    {
        return companyMapper.deleteCompanyById(id);
    }
}
