package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Lendmoney;

/**
 * 资金借出（期货）Service接口
 * 
 * @author ml
 * @date 2024-07-19
 */
public interface ILendmoneyService 
{
    /**
     * 查询资金借出（期货）
     * 
     * @param id 资金借出（期货）主键
     * @return 资金借出（期货）
     */
    public Lendmoney selectLendmoneyById(Long id);

    /**
     * 查询资金借出（期货）列表
     * 
     * @param lendmoney 资金借出（期货）
     * @return 资金借出（期货）集合
     */
    public List<Lendmoney> selectLendmoneyList(Lendmoney lendmoney);

    /**
     * 新增资金借出（期货）
     * 
     * @param lendmoney 资金借出（期货）
     * @return 结果
     */
    public int insertLendmoney(Lendmoney lendmoney);

    /**
     * 修改资金借出（期货）
     * 
     * @param lendmoney 资金借出（期货）
     * @return 结果
     */
    public int updateLendmoney(Lendmoney lendmoney);

    /**
     * 批量删除资金借出（期货）
     * 
     * @param ids 需要删除的资金借出（期货）主键集合
     * @return 结果
     */
    public int deleteLendmoneyByIds(Long[] ids);

    /**
     * 删除资金借出（期货）信息
     * 
     * @param id 资金借出（期货）主键
     * @return 结果
     */
    public int deleteLendmoneyById(Long id);
}
