package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import java.util.List;
import org.dzu.system.domain.LendMoney;

/**
 * 向外部借出款信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface LendMoneyMapper extends BaseMapper<LendMoney>
{
    /**
     * 查询向外部借出款信息
     * 
     * @param id 向外部借出款信息主键
     * @return 向外部借出款信息
     */
    public LendMoney selectLendMoneyById(Long id);

    /**
     * 查询向外部借出款信息列表
     * 
     * @param lendMoney 向外部借出款信息
     * @return 向外部借出款信息集合
     */
    public List<LendMoney> selectLendMoneyList(LendMoney lendMoney);

    /**
     * 新增向外部借出款信息
     * 
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    public int insertLendMoney(LendMoney lendMoney);

    /**
     * 修改向外部借出款信息
     * 
     * @param lendMoney 向外部借出款信息
     * @return 结果
     */
    public int updateLendMoney(LendMoney lendMoney);

    /**
     * 删除向外部借出款信息
     * 
     * @param id 向外部借出款信息主键
     * @return 结果
     */
    public int deleteLendMoneyById(Long id);

    /**
     * 批量删除向外部借出款信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLendMoneyByIds(Long[] ids);
}
