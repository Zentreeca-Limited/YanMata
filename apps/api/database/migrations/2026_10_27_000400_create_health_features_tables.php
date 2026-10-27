<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('health_services', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->string('name');
            $t->string('category'); // screening, maternal, mental_health, family_planning, specialist
            $t->string('provider_name');
            $t->string('provider_type')->default('hospital'); // hospital, clinic, specialist, wellness
            $t->string('address');
            $t->string('city')->default('Jos');
            $t->float('distance_km')->default(0.0);
            $t->string('price_range');
            $t->boolean('is_verified')->default(true);
            $t->boolean('is_available')->default(true);
            $t->text('description');
            $t->string('opening_hours')->default('Mon - Fri, 8:00 AM - 4:00 PM');
            $t->string('verification_source')->default('Plateau State Ministry of Health Facility Registry');
            $t->string('phone')->nullable();
            $t->timestamps();
        });

        Schema::create('health_products', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->string('name');
            $t->string('category'); // womens_health, vitamins, personal_care
            $t->string('pack_size');
            $t->unsignedInteger('price_ngn');
            $t->text('description');
            $t->string('seller_name')->default('Zentreeca Community Pharmacy Jos');
            $t->boolean('is_verified_seller')->default(true);
            $t->string('stock_status')->default('in_stock');
            $t->text('safety_info');
            $t->timestamps();
        });

        Schema::create('product_orders', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $t->string('customer_name');
            $t->string('customer_phone');
            $t->text('delivery_address');
            $t->unsignedInteger('total_ngn');
            $t->string('status')->default('confirmed');
            $t->text('items'); // JSON representation of ordered items
            $t->timestamps();
        });

        Schema::create('risk_assessments', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $t->string('age_group')->default('Adolescence (15–19)');
            $t->unsignedInteger('overall_risk_score')->default(38);
            $t->string('overall_risk_label')->default('Moderate');
            $t->unsignedInteger('cervical_risk_score')->default(38);
            $t->unsignedInteger('breast_risk_score')->default(22);
            $t->unsignedInteger('hormonal_risk_score')->default(41);
            $t->text('completed_sections'); // JSON map of completed sections
            $t->text('key_factors'); // JSON map of key risk factors
            $t->text('recommendations'); // JSON array of actionable recommendations
            $t->string('traceable_source')->default('WHO Cervical Cancer Elimination Initiative & FMOH National Guidelines');
            $t->timestamps();
        });

        Schema::create('mental_health_resources', function (Blueprint $t) {
            $t->uuid('id')->primary();
            $t->string('title');
            $t->string('category'); // anxiety, mood, postpartum, general
            $t->string('summary');
            $t->text('body');
            $t->text('coping_strategies'); // JSON array
            $t->string('emergency_helpline')->default('SURPIN Nigeria: 0800 123 4567 / Emergency: 112');
            $t->string('source_citation')->default('WHO Mental Health Atlas & Asido Foundation Nigeria');
            $t->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('mental_health_resources');
        Schema::dropIfExists('risk_assessments');
        Schema::dropIfExists('product_orders');
        Schema::dropIfExists('health_products');
        Schema::dropIfExists('health_services');
    }
};
