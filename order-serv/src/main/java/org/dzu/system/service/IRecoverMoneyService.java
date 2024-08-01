package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.RecoverMoney;

/**
 * 借出款收回信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IRecoverMoneyService 
{
    /**
     * 查询借出款收回信息
     * 
     * @param id 借出款收回信息主键
     * @return 借出款收回信息
     */
    public RecoverMoney selectRecoverMoneyById(Long id);

    /**
     * 查询借出款收回信息列表
     * 
     * @param recoverMoney 借出款收回信息
     * @return 借出款收回信息集合
     */
    public List<RecoverMoney> selectRecoverMoneyList(RecoverMoney recoverMoney);

    List<RecoverMoney> selectRecoverMoneyByFuturesNO(String futuresNO);

    /**
     * 新增借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    public int insertRecoverMoney(RecoverMoney recoverMoney);

    /**
     * 修改借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    public int updateRecoverMoney(RecoverMoney recoverMoney);

    /**
     * 批量删除借出款收回信息
     * 
     * @param ids 需要删除的借出款收回信息主键集合
     * @return 结果
     */
    public int deleteRecoverMoneyByIds(Long[] ids);

}
