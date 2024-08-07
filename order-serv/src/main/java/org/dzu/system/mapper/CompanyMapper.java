package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.Company;

import java.util.List;

/**
 * 客户、供应商信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface CompanyMapper extends BaseMapper<Company>
{
    /**
     * 查询客户、供应商信息
     * 
     * @param id 客户、供应商信息主键
     * @return 客户、供应商信息
     */
    public Company selectCompanyById(Long id);

    /**
     * 查询客户、供应商信息列表
     * 
     * @param company 客户、供应商信息
     * @return 客户、供应商信息集合
     */
    public List<Company> selectCompanyList(Company company);

    /**
     * 新增客户、供应商信息
     * 
     * @param company 客户、供应商信息
     * @return 结果
     */
    public int insertCompany(Company company);

    /**
     * 修改客户、供应商信息
     * 
     * @param company 客户、供应商信息
     * @return 结果
     */
    public int updateCompany(Company company);

    /**
     * 删除客户、供应商信息
     * 
     * @param id 客户、供应商信息主键
     * @return 结果
     */
    public int deleteCompanyById(Long id);

    /**
     * 批量删除客户、供应商信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCompanyByIds(Long[] ids);
}
