package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.ReceiveMoney;

/**
 * 收款信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IReceiveMoneyService 
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

    ReceiveMoney selectReceiveMoneyByReceiveNO(String receiveNO);

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
     * 批量删除收款信息
     * 
     * @param ids 需要删除的收款信息主键集合
     * @return 结果
     */
    public int deleteReceiveMoneyByIds(Long[] ids);

}
