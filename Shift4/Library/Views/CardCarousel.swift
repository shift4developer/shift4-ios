import Foundation
import UIKit

protocol DonationCarouselDelegate: AnyObject {
    func didTap(donation: Donation)
}

final class DonationCarousel: UICollectionView {
    var donations: [Donation] = [] {
        didSet {
            reloadData()
        }
    }

    var current: Donation {
        donations[currentIndex]
    }

    weak var cardCarouselDelegate: DonationCarouselDelegate?

    private var currentIndex = 0

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addConstraint(heightAnchor.constraint(equalToConstant: 116))
        (collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        (collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = CGSize(width: 150, height: 96)
        backgroundColor = .white
        delegate = self
        dataSource = self
        register(DonationCell.self, forCellWithReuseIdentifier: String(describing: DonationCell.self))
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension DonationCarousel: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        donations.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DonationCell.self), for: indexPath)
        guard let cell = dequeuedCell as? DonationCell else { return dequeuedCell }

        cell.configure(with: String(describing: donations[indexPath.row].readable), current: indexPath.row == currentIndex)

        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cardCarouselDelegate?.didTap(donation: donations[indexPath.row])
        currentIndex = indexPath.row
        reloadData()
    }
}
