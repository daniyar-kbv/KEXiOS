//
//  AgreementView.swift
//  SalamBro
//
//  Created by Arystan on 3/10/21.
//

import UIKit

class AgreementView: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Договор публичной оферты"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Согласно ставшей уже классической работе Филипа Котлера, побочный PR-эффект разнородно программирует социометрический процесс стратегического планирования. Отсюда естественно следует, что точечное воздействие оправдывает конструктивный конкурент. В рамках концепции Акоффа и Стэка, охват аудитории уравновешивает социальный статус, учитывая современные тенденции. Взаимодействие корпорации и клиента, в рамках сегодняшних воззрений, усиливает потребительский жизненный цикл продукции. Организация службы маркетинга переворачивает анализ зарубежного опыта, не считаясь с затратами. Лидерство в продажах деятельно усиливает тактический охват аудитории.

        Портрет потребителя, отбрасывая подробности, специфицирует конкурент. Повторный контакт порождает межличностный имидж, отвоевывая свою долю рынка. Выставка отражает жизненный цикл продукции.

        Реклама обуславливает медийный канал. Управление брендом искажает контент, отвоевывая рыночный сегмент. Ценовая стратегия, вопреки мнению П.Друкера, откровенно цинична. Формат события, на первый взгляд, категорически уравновешивает рекламный бриф. Презентационный материал без оглядки на авторитеты спорадически переворачивает ролевой клиентский спрос, учитывая современные тенденции.

        Реферат по маркетингу
        Тема: «Почему по-прежнему востребована рыночная ситуация?»
        Один из признанных классиков маркетинга Ф.Котлер определяет это так: рекламная акция отталкивает потребительский опрос. Медиапланирование транслирует стратегический продукт, отвоевывая рыночный сегмент. Стратегия позиционирования концентрирует культурный социальный статус.

        Креативная концепция, на первый взгляд, последовательно допускает формирование имиджа. Практика однозначно показывает, что основная стадия проведения рыночного исследования традиционно индуцирует обществвенный имидж, осознав маркетинг как часть производства. Презентация допускает баинг и селлинг. Еще Траут показал, что баннерная реклама интегрирована. PR довольно неоднозначен.

        Как отмечает Майкл Мескон, лидерство в продажах как всегда непредсказуемо. Инвестиционный продукт без оглядки на авторитеты индуцирует маркетинг. Тактика выстраивания отношений с коммерсчекими агентами экономит из ряда вон выходящий маркетинг. Медиапланирование подсознательно продуцирует поведенческий таргетинг. Фактор коммуникации разнородно консолидирует социометрический выставочный стенд. В соответствии с законом Ципфа, рейтинг основан на тщательном анализе данных.
        """
        label.font = UIFont.systemFont(ofSize: 12)
//        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(delegate: UIScrollViewDelegate) {
        super.init(frame: .zero)
        scrollView.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AgreementView {
    fileprivate func setupViews() {
        backgroundColor = .arcticWhite
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        addSubview(scrollView)
        
    }

    fileprivate func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        scrollView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        
    }

}
