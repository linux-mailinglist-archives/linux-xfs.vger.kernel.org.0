Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9739B50DA63
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Apr 2022 09:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbiDYHvg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Apr 2022 03:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241398AbiDYHvQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 03:51:16 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD03A113
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 00:47:42 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id a186so10180651qkc.10
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 00:47:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=db1Gh+dbbOkrs3+CkezCcfSMDq6/zhG+HKIUQBCn3xYADIM41sZSQFz/URHmkIisCL
         7pZqnx/TdzbQawzzOfVElh+os1jZ2B9DLHIcxPsugnMI2M60YoWhe6xuoTkc56KEVSLM
         Pzsu1OHG9mQrp4lqlx/Fsm/MgAHKlkoWkHGXoHCcHeEBfO5/AaRI4BK2JRNgFn3H25Hf
         7ohYxgBKcu12J83jIEDH6BxScVW1GelrhCkauZMny4G64qD/PKLpRMyIv57TGM7jCMZ/
         F4xJI/A3kH4PlBjxvGzqvF0tIGbqAyfuz+YHLeXY+XH8CEpJJC1W4rRJCO+8CsZT+tKE
         IcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=1Br/N6WhyVMlujnGsxiPG2oa5QW+rtf7KlXAbdHBbwA=;
        b=EeVm53qwUhXr6xqwnSCggIkS1dw77KjBeyeS+E8fo6dFsYijTK5y7wjVIijNCOxlud
         rbjNWUW6YGcCOoAWfCZ2ObocqqeS9ilo3ImFhYxBbOa9mX8hYCPOrZipCMYCcxmo1bq8
         ST7XhvjNhWl5pQoiXDOWUAgp1oT8Vvgyf7S16Bfrr41npPyAis8kVRHrOAwgeOfCCiDh
         L3Yv5vk4U8nYVXfJgBs8ElobZa8YYQmPYEq9dMpN64jVUqe75VfQmEwOIVcxLXJma3IX
         K2/OtvSLfsVRrSVvtUBEsG+nXwt3SV5PALHlUwJRRjTd9WuA5lqzxTjISUG31OrzyqpF
         79Pw==
X-Gm-Message-State: AOAM533hK4L73D6yauvvNrxjwAOPWBemaYn8kgw0Gdx7RdaGHXBBGCfd
        a4RSWySkCN6GzqlrAZDmNVes/aiQbMn4X4aRb0Q=
X-Google-Smtp-Source: ABdhPJwK2ygbdOaO2kPYyQtxAKKpUe9yIQ/KzfJixnpIpudQmiJIYiw+C7F9wb46BqVjsq0hsQNZFPuVjD2jZtPrySQ=
X-Received: by 2002:a05:620a:178f:b0:69f:4d61:e1b1 with SMTP id
 ay15-20020a05620a178f00b0069f4d61e1b1mr2520843qkb.523.1650872862066; Mon, 25
 Apr 2022 00:47:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac8:7fcc:0:0:0:0:0 with HTTP; Mon, 25 Apr 2022 00:47:41
 -0700 (PDT)
Reply-To: mrsbillchantallawrence58@gmail.com
From:   chantal <mrs.samira7@gmail.com>
Date:   Mon, 25 Apr 2022 00:47:41 -0700
Message-ID: <CANv7eTvCyLtFwvViHgNUoYSGG3RNObUt1Qv=6cJBHUsE9YqutQ@mail.gmail.com>
Subject: dear frinds incase my connession is not good
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:72d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5055]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrs.samira7[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrsbillchantallawrence58[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrs.samira7[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  0.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  2.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

hello....

You have been compensated with the sum of 5.5 million dollars in this
united nation the payment will be issue into atm visa card and send to
you from the santander bank we need your address and your  Whatsapp
this my email.ID (  mrsbillchantallawrence58@gmail.com)  contact  me

Thanks my

mrs chantal
