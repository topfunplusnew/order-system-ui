package org.dzu.system.mapper;

import java.util.List;
import org.dzu.system.domain.Lendmoney;

/**
 * 借贷Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface LendmoneyMapper 
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
     * 删除借贷
     * 
     * @param id 借贷主键
     * @return 结果
     */
    public int deleteLendmoneyById(Long id);

    /**
     * 批量删除借贷
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteLendmoneyByIds(Long[] ids);
}
