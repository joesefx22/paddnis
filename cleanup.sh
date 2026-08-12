#!/usr/bin/env bash
# =====================================================================
# سكريبت تحويل مشروع Mercur/Medusa Marketplace إلى متجر فردي (Single-Vendor)
# ينفَّذ من جذر الـ Monorepo (حيث يوجد turbo.json)
# =====================================================================
set -euo pipefail

ROOT_DIR="$(pwd)"
echo "==> جذر المشروع: $ROOT_DIR"
if [ ! -f "$ROOT_DIR/turbo.json" ]; then
  echo "خطأ: نفّذ هذا السكريبت من جذر الـ monorepo (حيث يوجد turbo.json)."
  exit 1
fi

# ---------------------------------------------------------------------
# المرحلة 0: إنشاء فرع Git مخصص لحفظ حالة المشروع والتراجع عند الحاجة
# ---------------------------------------------------------------------
echo "==> [0/8] إنشاء فرع Git آمن..."
git checkout -b chore/strip-marketplace-to-single-vendor || {
  echo "تحذير: تعذر إنشاء الفرع (ربما موجود مسبقاً). تأكد من حفظ التغييرات الحالية أولاً."
}

# دالة مساعدة للحذف الآمن (لا توقف السكريبت إن كان المسار غير موجود)
safe_rm() {
  local path="$1"
  if [ -e "$path" ]; then
    rm -rf -- "$path"
    echo "  [DELETED] $path"
  else
    echo "  [SKIP - غير موجود] $path"
  fi
}

# =====================================================================
# المرحلة 1: تنظيف apps/storefront (واجهة المتجر)
# =====================================================================
echo "==> [1/8] تنظيف مكونات وصفحات الواجهة الخاصة بالتجار..."

SF="apps/storefront/src"

safe_rm "$SF/app/[locale]/(main)/sellers"

safe_rm "$SF/components/cells/ProductDetailsSeller"
safe_rm "$SF/components/cells/ProductDetailsSellerReviews"
safe_rm "$SF/components/cells/SellerAvatar"
safe_rm "$SF/components/cells/SellerRatingFilter"
safe_rm "$SF/components/cells/SellNowButton"

safe_rm "$SF/components/molecules/ReportSellerForm"
safe_rm "$SF/components/molecules/SellerInfo"
safe_rm "$SF/components/molecules/SellerInfoHeader"
safe_rm "$SF/components/molecules/SellerReview"
safe_rm "$SF/components/molecules/SellerReviewList"
safe_rm "$SF/components/molecules/SellerScore"

safe_rm "$SF/components/organisms/SellerFooter"
safe_rm "$SF/components/organisms/SellerHeading"
safe_rm "$SF/components/organisms/SellerTabs"
safe_rm "$SF/components/organisms/CompareOffersModal"
safe_rm "$SF/components/organisms/OfferCard"

safe_rm "$SF/sections/SellerOffersListing"
safe_rm "$SF/sections/SellerPageHeader"

safe_rm "$SF/lib/helpers/buybox.ts"
safe_rm "$SF/lib/helpers/get-seller-product-price.ts"
safe_rm "$SF/types/seller.ts"

# ملاحظة: تم الإبقاء على TalkJS ونظام المحادثة بالكامل دون مساس لاستخدامه في الدعم الفني.

# =====================================================================
# المرحلة 2: تنظيف packages/admin (لوحة التحكم)
# =====================================================================
echo "==> [2/8] تنظيف صفحات وهوكات لوحة التحكم..."

AD="packages/admin/src"

safe_rm "$AD/pages/commissions"
safe_rm "$AD/pages/offers"
safe_rm "$AD/pages/payouts"
safe_rm "$AD/pages/stores"

safe_rm "$AD/hooks/api/commissions.tsx"
safe_rm "$AD/hooks/api/offers.tsx"
safe_rm "$AD/hooks/api/payouts.tsx"
safe_rm "$AD/hooks/api/sellers.tsx"

safe_rm "$AD/hooks/table/columns/use-commission-rules-table-columns.tsx"
safe_rm "$AD/hooks/table/columns/use-payout-table-columns.tsx"
safe_rm "$AD/hooks/table/columns/use-seller-table-columns.tsx"
safe_rm "$AD/hooks/table/filters/use-seller-table-filters.tsx"
safe_rm "$AD/hooks/table/query/use-commission-rules-table-query.tsx"
safe_rm "$AD/hooks/table/query/use-payout-table-query.tsx"
safe_rm "$AD/hooks/table/query/use-seller-orders-table-query.tsx"
safe_rm "$AD/hooks/table/query/use-sellers-table-query.tsx"

safe_rm "$AD/table/table-cells/product/seller-cell"
safe_rm "$AD/table/table-cells/seller"

safe_rm "$AD/pages/inventory/inventory-detail/components/inventory-item-offers"
safe_rm "$AD/pages/orders/order-detail/components/order-remaining-orders-group-section"
safe_rm "$AD/pages/products/product-detail/components/product-active-request-section"

# =====================================================================
# المرحلة 3: تنظيف modules الخاصة بالتاجر (packages/core/src/modules)
# =====================================================================
echo "==> [3/8] تنظيف وحدات الموديولات الخاصة بالتجار والعمولات..."

CM="packages/core/src/modules"

safe_rm "$CM/commission"
safe_rm "$CM/offer"
safe_rm "$CM/payout"
safe_rm "$CM/product-edit"
safe_rm "$CM/promotion-cost"
safe_rm "$CM/seller"
safe_rm "$CM/vendor-ui"

# =====================================================================
# المرحلة 4: تنظيف workflows (packages/core/src/workflows)
# =====================================================================
echo "==> [4/8] تنظيف تدفقات العمل (Workflows)..."

CW="packages/core/src/workflows"

safe_rm "$CW/campaign"
safe_rm "$CW/commission"
safe_rm "$CW/customer-group"
safe_rm "$CW/inventory-item"
safe_rm "$CW/offer"
safe_rm "$CW/order-group"
safe_rm "$CW/payout"
safe_rm "$CW/price-list"
safe_rm "$CW/product-edit"
safe_rm "$CW/promotion-cost"
safe_rm "$CW/seller"
safe_rm "$CW/shipping-option"
safe_rm "$CW/shipping-profile"
safe_rm "$CW/stock-location"

safe_rm "$CW/product/steps/associate-sellers-with-product-category.ts"
safe_rm "$CW/product/steps/associate-sellers-with-product.ts"
safe_rm "$CW/product/steps/detach-sellers-from-product-category.ts"
safe_rm "$CW/product/steps/detach-sellers-from-product.ts"
safe_rm "$CW/product/steps/validate-seller-product-permissions.ts"
safe_rm "$CW/product/workflows/confirm-products.ts"
safe_rm "$CW/product/workflows/link-sellers-to-product-category.ts"
safe_rm "$CW/product/workflows/link-sellers-to-product.ts"
safe_rm "$CW/product/workflows/reject-product.ts"
safe_rm "$CW/product/workflows/request-product-change.ts"

safe_rm "$CW/cart/steps/link-line-item-to-offer.ts"
safe_rm "$CW/cart/steps/mirror-line-item-offer-links-to-order.ts"
safe_rm "$CW/cart/steps/validate-seller-cart-items.ts"
safe_rm "$CW/cart/steps/validate-seller-cart-shipping.ts"
safe_rm "$CW/cart/workflows/add-seller-shipping-method-to-cart.ts"
safe_rm "$CW/cart/workflows/complete-cart-with-split-orders.ts"
safe_rm "$CW/cart/workflows/list-seller-shipping-options-for-cart.ts"
safe_rm "$CW/cart/workflows/update-cart-seller-promotions.ts"

# =====================================================================
# المرحلة 5: تنظيف الروابط والـ API والخدمات
# =====================================================================
echo "==> [5/8] تنظيف الروابط (Links) والمسارات البرمجية..."

CS="packages/core/src"

for f in \
  campaign-seller-link.ts \
  cart-line-item-offer-link.ts \
  category-seller-link.ts \
  fulfillment-set-seller-link.ts \
  inventory-item-seller-link.ts \
  offer-inventory-item-link.ts \
  offer-price-link.ts \
  offer-product-link.ts \
  offer-seller-link.ts \
  offer-shipping-profile-link.ts \
  offer-variant-link.ts \
  order-group-cart-link.ts \
  order-group-order-link.ts \
  order-line-item-offer-link.ts \
  order-payout-link.ts \
  order-seller-link.ts \
  payout-seller-link.ts \
  price-list-seller-link.ts \
  product-change-link.ts \
  product-seller-link.ts \
  promotion-cost-link.ts \
  promotion-seller-link.ts \
  seller-customer-group-link.ts \
  seller-customer-link.ts \
  seller-member-rbac-role.ts \
  seller-payout-account-link.ts \
  seller-review.ts \
  service-zone-seller-link.ts \
  shipping-option-seller-link.ts \
  shipping-profile-seller-link.ts \
  stock-location-seller-link.ts \
; do
  safe_rm "$CS/links/$f"
done

safe_rm "$CS/api/admin/commission-rates"
safe_rm "$CS/api/admin/offers"
safe_rm "$CS/api/admin/payouts"
safe_rm "$CS/api/admin/sellers"
safe_rm "$CS/api/admin/product-changes"
safe_rm "$CS/api/admin/order-groups"

safe_rm "$CS/api/admin/product-categories/[id]/sellers"
safe_rm "$CS/api/admin/products/[id]/sellers"
safe_rm "$CS/api/admin/products/[id]/confirm"
safe_rm "$CS/api/admin/products/[id]/reject"
safe_rm "$CS/api/admin/products/[id]/request-changes"
safe_rm "$CS/api/admin/orders/resolve-order-seller-id.ts"
safe_rm "$CS/api/admin/orders/[id]/commission-lines"
safe_rm "$CS/api/admin/orders/[id]/order-group"
safe_rm "$CS/api/admin/promotions/[id]/cost"

safe_rm "$CS/api/store/offers"
safe_rm "$CS/api/store/order-groups"
safe_rm "$CS/api/store/sellers"

safe_rm "$CS/api/hooks/payout"

for f in \
  ensure-seller-middleware.ts \
  filter-by-seller-id.ts \
  offers.ts \
  order-commission-lines.ts \
  sellers.ts \
  vendor-cors-middleware.ts \
; do
  safe_rm "$CS/api/utils/$f"
done

safe_rm "$CS/feature-flags/seller-registration.ts"
safe_rm "$CS/feature-flags/product-request.ts"
safe_rm "$CS/policies/seller.ts"
safe_rm "$CS/subscribers/link-order-line-items-to-offers.ts"
safe_rm "$CS/subscribers/payout-webhook.ts"
safe_rm "$CS/types/seller-context.ts"

# =====================================================================
# المرحلة 6: تنظيف packages/types
# =====================================================================
echo "==> [6/8] تنظيف حزم تعريفات TypeScript..."

TP="packages/types/src"

safe_rm "$TP/commission"
safe_rm "$TP/offer"
safe_rm "$TP/order-group"
safe_rm "$TP/payout"
safe_rm "$TP/seller"

safe_rm "$TP/http/commission.ts"
safe_rm "$TP/http/offer.ts"
safe_rm "$TP/http/order-group.ts"
safe_rm "$TP/http/payout.ts"
safe_rm "$TP/http/seller.ts"

# =====================================================================
# المرحلة 7: البحث عن أي استيرادات متبقية للكود المحذوف
# =====================================================================
echo "==> [7/8] فحص المراجع المتبقية (Imports) قبل التعديل اليدوي..."

SEARCH_DIRS="apps packages"
PATTERNS=(
  "from .*/seller"
  "from .*/commission"
  "from .*/payout"
  "from .*/offer"
  "from .*/order-group"
  "from .*/vendor-ui"
  "from .*/product-edit"
  "from .*/promotion-cost"
  "buybox"
)

for pattern in "${PATTERNS[@]}"; do
  echo "---- Search: '$pattern' ----"
  grep -rn --include="*.ts" --include="*.tsx" -E "$pattern" $SEARCH_DIRS \
    | grep -v "node_modules" \
    | grep -v "/dist/" \
    || echo "    (لا يوجد استيرادات معلقة)"
  echo ""
done

# =====================================================================
# المرحلة 8: الخطوات التالية
# =====================================================================
echo "====================================================================="
echo "==> اكتمل سكريبت الحذف بنجاح!"
echo "==> نفّذ التعديلات اليدوية المذكورة سابقاً في ملفات index.ts و medusa-config.ts"
echo "==> ثم شغّل الأمر التالي لفحص التوافقية وإصلاح أخطاء الـ Imports:"
echo "    pnpm turbo run typecheck"
echo "====================================================================="