package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Socialinsurance;

/**
 * 社保基金Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ISocialinsuranceService 
{
    /**
     * 查询社保基金
     * 
     * @param id 社保基金主键
     * @return 社保基金
     */
    public Socialinsurance selectSocialinsuranceById(Long id);

    /**
     * 查询社保基金列表
     * 
     * @param socialinsurance 社保基金
     * @return 社保基金集合
     */
    public List<Socialinsurance> selectSocialinsuranceList(Socialinsurance socialinsurance);

    /**
     * 新增社保基金
     * 
     * @param socialinsurance 社保基金
     * @return 结果
     */
    public int insertSocialinsurance(Socialinsurance socialinsurance);

    /**
     * 修改社保基金
     * 
     * @param socialinsurance 社保基金
     * @return 结果
     */
    public int updateSocialinsurance(Socialinsurance socialinsurance);

    /**
     * 批量删除社保基金
     * 
     * @param ids 需要删除的社保基金主键集合
     * @return 结果
     */
    public int deleteSocialinsuranceByIds(Long[] ids);

    /**
     * 删除社保基金信息
     * 
     * @param id 社保基金主键
     * @return 结果
     */
    public int deleteSocialinsuranceById(Long id);
}
