// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_plans_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPlansResponse _$UserPlansResponseFromJson(Map<String, dynamic> json) =>
    UserPlansResponse(
      subscriptions: (json['subscriptions'] as List<dynamic>)
          .map((e) => e == null
              ? null
              : UserPlansBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      otherSubscriptions: json['other_subscriptions'] as bool,
    );

Map<String, dynamic> _$UserPlansResponseToJson(UserPlansResponse instance) =>
    <String, dynamic>{
      'subscriptions': instance.subscriptions,
      'other_subscriptions': instance.otherSubscriptions,
    };

UserPlansBean _$UserPlansBeanFromJson(Map<String, dynamic> json) =>
    UserPlansBean(
      ID: json['ID'] as String,
      id: json['id'] as String,
      subscriptionId: json['subscription_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      confirmation: json['confirmation'] as String,
      expirationNumber: json['expiration_number'] as String,
      expirationPeriod: json['expiration_period'] as String,
      initialPayment: json['initial_payment'] as num,
      billingAmount: json['billing_amount'] as num,
      cycleNumber: json['cycle_number'] as String,
      cyclePeriod: json['cycle_period'] as String,
      billingLimit: json['billing_limit'] as String,
      trialAmount: json['trial_amount'] as num,
      trialLimit: json['trial_limit'] as String,
      codeId: json['code_id'] as String,
      startdate: json['startdate'] as String,
      enddate: json['enddate'] as String,
      courseNumber: json['course_number'] as String,
      usedQuotas: json['used_quotas'] as num,
      quotasLeft: json['quotas_left'] as num,
      button: json['button'] == null
          ? null
          : ButtonBean.fromJson(json['button'] as Map<String, dynamic>),
      features: json['features'] as String,
    );

Map<String, dynamic> _$UserPlansBeanToJson(UserPlansBean instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'id': instance.id,
      'subscription_id': instance.subscriptionId,
      'name': instance.name,
      'description': instance.description,
      'confirmation': instance.confirmation,
      'expiration_number': instance.expirationNumber,
      'expiration_period': instance.expirationPeriod,
      'initial_payment': instance.initialPayment,
      'billing_amount': instance.billingAmount,
      'cycle_number': instance.cycleNumber,
      'cycle_period': instance.cyclePeriod,
      'billing_limit': instance.billingLimit,
      'trial_amount': instance.trialAmount,
      'trial_limit': instance.trialLimit,
      'code_id': instance.codeId,
      'startdate': instance.startdate,
      'enddate': instance.enddate,
      'course_number': instance.courseNumber,
      'features': instance.features,
      'used_quotas': instance.usedQuotas,
      'quotas_left': instance.quotasLeft,
      'button': instance.button,
    };

ButtonBean _$ButtonBeanFromJson(Map<String, dynamic> json) => ButtonBean(
      text: json['text'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$ButtonBeanToJson(ButtonBean instance) =>
    <String, dynamic>{
      'text': instance.text,
      'url': instance.url,
    };
