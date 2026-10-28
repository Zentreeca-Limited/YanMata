<?php

namespace App\Http\Controllers;

use App\Models\HealthProduct;
use App\Models\ProductOrder;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class HealthProductController extends Controller
{
    public function index(Request $request)
    {
        $query = HealthProduct::query();

        if ($request->filled('category') && $request->category !== 'all') {
            $query->where('category', $request->category);
        }

        if ($request->filled('query')) {
            $q = $request->query('query');
            $query->where(function ($sub) use ($q) {
                $sub->where('name', 'like', "%{$q}%")
                    ->orWhere('description', 'like', "%{$q}%");
            });
        }

        return response()->json([
            'data' => $query->get(),
        ]);
    }

    public function show(string $id)
    {
        $product = HealthProduct::findOrFail($id);

        return response()->json(['data' => $product]);
    }

    public function order(Request $request)
    {
        $data = $request->validate([
            'customer_name' => 'required|string|max:120',
            'customer_phone' => 'required|string|max:30',
            'delivery_address' => 'required|string|max:500',
            'total_ngn' => 'required|integer|min:0',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|string',
            'items.*.name' => 'required|string',
            'items.*.quantity' => 'required|integer|min:1',
            'items.*.price_ngn' => 'required|integer|min:0',
        ]);

        $order = ProductOrder::create([
            'id' => (string) Str::uuid(),
            'user_id' => $request->user()->id,
            'customer_name' => $data['customer_name'],
            'customer_phone' => $data['customer_phone'],
            'delivery_address' => $data['delivery_address'],
            'total_ngn' => $data['total_ngn'],
            'status' => 'confirmed',
            'items' => $data['items'],
        ]);

        return response()->json([
            'data' => $order,
            'message' => 'Your order has been placed with the verified seller.',
        ], 201);
    }

    public function myOrders(Request $request)
    {
        $orders = ProductOrder::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json(['data' => $orders]);
    }
}
