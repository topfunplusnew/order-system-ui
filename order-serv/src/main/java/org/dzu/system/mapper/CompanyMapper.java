package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Company;

/**
 * 公司信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface CompanyMapper 
{
    /**
     * 查询公司信息
     * 
     * @param id 公司信息主键
     * @return 公司信息
     */
    public Company selectCompanyById(Long id);

    /**
     * 查询公司信息列表
     * 
     * @param company 公司信息
     * @return 公司信息集合
     */
    public List<Company> selectCompanyList(Company company);

    /**
     * 新增公司信息
     * 
     * @param company 公司信息
     * @return 结果
     */
    public int insertCompany(Company company);

    /**
     * 修改公司信息
     * 
     * @param company 公司信息
     * @return 结果
     */
    public int updateCompany(Company company);

    /**
     * 删除公司信息
     * 
     * @param id 公司信息主键
     * @return 结果
     */
    public int deleteCompanyById(Long id);

    /**
     * 批量删除公司信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCompanyByIds(Long[] ids);
}
