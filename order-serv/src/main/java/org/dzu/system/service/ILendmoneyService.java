package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Lendmoney;

/**
 * 借贷Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface ILendmoneyService 
{
    /**
     * 查询借贷
     * 
     * @param id 借贷主键
     * @return 借贷
     */
    public Lendmoney selectLendmoneyById(Long id);

    /**
     * 查询借贷列表
     * 
     * @param lendmoney 借贷
     * @return 借贷集合
     */
    public List<Lendmoney> selectLendmoneyList(Lendmoney lendmoney);

    /**
     * 新增借贷
     * 
     * @param lendmoney 借贷
     * @return 结果
     */
    public int insertLendmoney(Lendmoney lendmoney);

    /**
     * 修改借贷
     * 
     * @param lendmoney 借贷
     * @return 结果
     */
    public int updateLendmoney(Lendmoney lendmoney);

    /**
     * 批量删除借贷
     * 
     * @param ids 需要删除的借贷主键集合
     * @return 结果
     */
    public int deleteLendmoneyByIds(Long[] ids);

    /**
     * 删除借贷信息
     * 
     * @param id 借贷主键
     * @return 结果
     */
    public int deleteLendmoneyById(Long id);
}
