package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.OilCardConsume;

/**
 * 加油卡消费信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IOilCardConsumeService 
{
    /**
     * 查询加油卡消费信息
     * 
     * @param id 加油卡消费信息主键
     * @return 加油卡消费信息
     */
    public OilCardConsume selectOilCardConsumeById(Long id);

    /**
     * 查询加油卡消费信息列表
     * 
     * @param oilCardConsume 加油卡消费信息
     * @return 加油卡消费信息集合
     */
    public List<OilCardConsume> selectOilCardConsumeList(OilCardConsume oilCardConsume);

    /**
     * 新增加油卡消费信息
     * 
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    public int insertOilCardConsume(OilCardConsume oilCardConsume);

    /**
     * 修改加油卡消费信息
     * 
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    public int updateOilCardConsume(OilCardConsume oilCardConsume);

    /**
     * 批量删除加油卡消费信息
     * 
     * @param ids 需要删除的加油卡消费信息主键集合
     * @return 结果
     */
    public int deleteOilCardConsumeByIds(Long[] ids);

    /**
     * 删除加油卡消费信息信息
     * 
     * @param id 加油卡消费信息主键
     * @return 结果
     */
    public int deleteOilCardConsumeById(Long id);

}
