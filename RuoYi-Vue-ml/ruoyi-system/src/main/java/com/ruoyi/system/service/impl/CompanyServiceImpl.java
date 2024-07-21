package com.ruoyi.system.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.CompanyMapper;
import com.ruoyi.system.domain.Company;
import com.ruoyi.system.service.ICompanyService;

/**
 * 公司信息Service业务层处理
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
@Service
public class CompanyServiceImpl implements ICompanyService 
{
    @Autowired
    private CompanyMapper companyMapper;

    /**
     * 查询公司信息
     * 
     * @param id 公司信息主键
     * @return 公司信息
     */
    @Override
    public Company selectCompanyById(Long id)
    {
        return companyMapper.selectCompanyById(id);
    }

    /**
     * 查询公司信息列表
     * 
     * @param company 公司信息
     * @return 公司信息
     */
    @Override
    public List<Company> selectCompanyList(Company company)
    {
        return companyMapper.selectCompanyList(company);
    }

    /**
     * 新增公司信息
     * 
     * @param company 公司信息
     * @return 结果
     */
    @Override
    public int insertCompany(Company company)
    {
        return companyMapper.insertCompany(company);
    }

    /**
     * 修改公司信息
     * 
     * @param company 公司信息
     * @return 结果
     */
    @Override
    public int updateCompany(Company company)
    {
        company.setUpdateTime(DateUtils.getNowDate());
        return companyMapper.updateCompany(company);
    }

    /**
     * 批量删除公司信息
     * 
     * @param ids 需要删除的公司信息主键
     * @return 结果
     */
    @Override
    public int deleteCompanyByIds(Long[] ids)
    {
        return companyMapper.deleteCompanyByIds(ids);
    }

    /**
     * 删除公司信息信息
     * 
     * @param id 公司信息主键
     * @return 结果
     */
    @Override
    public int deleteCompanyById(Long id)
    {
        return companyMapper.deleteCompanyById(id);
    }
}
