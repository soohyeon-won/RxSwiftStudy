//
//  Preview.swift
//  RxSwiftStudyInUIkit
//
//  Created by soohyeon won on 2022/09/16.
//
import UIKit
import SwiftUI

class MyYellowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("not support coder")
    }

    // MARK: - Private

    private func setupView() {
        backgroundColor = .yellow
        setTitleColor(.black, for: .normal)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyYellowButtonPreview: PreviewProvider{
    static var previews: some View {
        UIViewPreview {
            let button = MyYellowButton(frame: .zero)
            button.setTitle("buttonTestTest!!!", for: .normal)
            return button
        }.previewLayout(.sizeThatFits)
    }
}
#endif

#if canImport(SwiftUI) && DEBUG
import SwiftUI
struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
        view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
