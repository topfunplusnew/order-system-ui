package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.ReceiveMoney;

import java.util.List;

/**
 * 收款信息Mapper接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface ReceiveMoneyMapper extends BaseMapper<ReceiveMoney>
{
    /**
     * 查询收款信息
     * 
     * @param id 收款信息主键
     * @return 收款信息
     */
    public ReceiveMoney selectReceiveMoneyById(Long id);

    /**
     * 查询收款信息列表
     * 
     * @param receiveMoney 收款信息
     * @return 收款信息集合
     */
    public List<ReceiveMoney> selectReceiveMoneyList(ReceiveMoney receiveMoney);

    /**
     * 新增收款信息
     * 
     * @param receiveMoney 收款信息
     * @return 结果
     */
    public int insertReceiveMoney(ReceiveMoney receiveMoney);

    /**
     * 修改收款信息
     * 
     * @param receiveMoney 收款信息
     * @return 结果
     */
    public int updateReceiveMoney(ReceiveMoney receiveMoney);

    /**
     * 删除收款信息
     * 
     * @param id 收款信息主键
     * @return 结果
     */
    public int deleteReceiveMoneyById(Long id);

    /**
     * 批量删除收款信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteReceiveMoneyByIds(Long[] ids);
}
