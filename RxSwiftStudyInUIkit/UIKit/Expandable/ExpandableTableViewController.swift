//
//  ExpandableTableViewController.swift
//  RxSwiftStudyInUIkit
//
//  Created by won soohyeon on 2022/08/27.
//

import UIKit
import RxSwift

struct SectionList {
    
    var list: [Section] = [Section]()
    
    struct Section {
        let title: String
        let rowList: [Data]
        
        struct Data {
            let rowTitle: String
        }
    }
}

final class ExpandableViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private var data = SectionList()
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.bounces = false
        $0.separatorStyle = .none
        $0.rowHeight = 40
        $0.sectionHeaderHeight = 22
        $0.sectionFooterHeight = 0
        $0.delegate = self
        $0.dataSource = self
        $0.register(BaseTextTableViewCell.self)
    }
    var showSections = Set<Int>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        setupData()
    }
    
    func setupData() {
        for i in 0..<100 {
            var rowList = [SectionList.Section.Data]()
            for j in 0..<2 {
                rowList.append(SectionList.Section.Data(rowTitle: "row \(j)"))
            }
            data.list.append(SectionList.Section(title: "section \(i)", rowList: rowList))
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ExpandableViewController: UITableViewDelegate {
    
}

extension ExpandableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BaseTextTableViewCell()
        cell.label.text = data.list[indexPath.section].rowList[indexPath.row].rowTitle
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ????????? hidden????????? ?????? ??????????????? ?????????.
        if showSections.contains(section) {
            return data.list[section].rowList.count
            
        }
        
        print("hiddenSections: \(showSections)")
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        
            sectionButton.setTitle(String(section),
                                   for: .normal)
            sectionButton.backgroundColor = .systemBlue
            
            // tag??? ????????? ????????? ?????????.
            sectionButton.tag = section
        if section % 2 == 0 {
            // section??? ???????????? ??? ????????? ????????? ??????(????????? ????????????.)
            sectionButton.addTarget(self,
                                    action: #selector(self.hideSection(sender:)),
                                    for: .touchUpInside)
        }

        return sectionButton
    }
    
    @objc
    private func hideSection(sender: UIButton) {
        // section??? tag ????????? ???????????? ?????? ???????????? ????????????.
        let section = sender.tag
        
        // ?????? ????????? ?????? ????????? IndexPath?????? ???????????? ?????????
        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()
            
            for row in 0..<data.list[section].rowList.count {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }
            
            return indexPaths
        }
        
        if self.showSections.contains(section) {
            // section??? ?????? ???????????? ???????????? ????????? ?????????.
            self.showSections.remove(section)
            self.tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        } else { // ????????? section??? ?????? ????????? ????????????
            // section??? ?????? ???????????????.
            self.showSections.insert(section)
            self.tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
            // ????????? ??????????????? ?????? ????????? ?????? ????????? ??? ?????? ??? ?????? ??????.
            self.tableView.scrollToRow(at: IndexPath(row: data.list[section].rowList.count - 1,
                                                     section: section), at: UITableView.ScrollPosition.none, animated: true)
        }
    }
}
