package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.Socialinsurance;

/**
 * 社会保险信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-07-18
 */
public interface SocialinsuranceMapper 
{
    /**
     * 查询社会保险信息
     * 
     * @param id 社会保险信息主键
     * @return 社会保险信息
     */
    public Socialinsurance selectSocialinsuranceById(Long id);

    /**
     * 查询社会保险信息列表
     * 
     * @param socialinsurance 社会保险信息
     * @return 社会保险信息集合
     */
    public List<Socialinsurance> selectSocialinsuranceList(Socialinsurance socialinsurance);

    /**
     * 新增社会保险信息
     * 
     * @param socialinsurance 社会保险信息
     * @return 结果
     */
    public int insertSocialinsurance(Socialinsurance socialinsurance);

    /**
     * 修改社会保险信息
     * 
     * @param socialinsurance 社会保险信息
     * @return 结果
     */
    public int updateSocialinsurance(Socialinsurance socialinsurance);

    /**
     * 删除社会保险信息
     * 
     * @param id 社会保险信息主键
     * @return 结果
     */
    public int deleteSocialinsuranceById(Long id);

    /**
     * 批量删除社会保险信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSocialinsuranceByIds(Long[] ids);
}
