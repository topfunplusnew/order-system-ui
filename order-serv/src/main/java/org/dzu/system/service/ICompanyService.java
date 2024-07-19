package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Company;

/**
 * 客户管理Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface ICompanyService 
{
    /**
     * 查询客户管理
     * 
     * @param id 客户管理主键
     * @return 客户管理
     */
    public Company selectCompanyById(Long id);

    /**
     * 查询客户管理列表
     * 
     * @param company 客户管理
     * @return 客户管理集合
     */
    public List<Company> selectCompanyList(Company company);

    /**
     * 新增客户管理
     * 
     * @param company 客户管理
     * @return 结果
     */
    public int insertCompany(Company company);

    /**
     * 修改客户管理
     * 
     * @param company 客户管理
     * @return 结果
     */
    public int updateCompany(Company company);

    /**
     * 批量删除客户管理
     * 
     * @param ids 需要删除的客户管理主键集合
     * @return 结果
     */
    public int deleteCompanyByIds(Long[] ids);

    /**
     * 删除客户管理信息
     * 
     * @param id 客户管理主键
     * @return 结果
     */
    public int deleteCompanyById(Long id);
}
