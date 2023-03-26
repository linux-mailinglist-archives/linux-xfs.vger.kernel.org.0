Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6BE6C9657
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Mar 2023 17:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjCZP5T (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Mar 2023 11:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231659AbjCZP5S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Mar 2023 11:57:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208F14220
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 08:57:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id ja10so6215418plb.5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Mar 2023 08:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679846236;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YzwnjkUenmiZUEBZjCVaStCmhFT11zV1dVjxIZMZJd0=;
        b=aUvEyt1YD+mIydWxTKiD74QRnJzfKKp9ZT2AHo1dCs1/RwMJ2gr441wuOM6/LQxreO
         W3R7jsvyKrM2JS655pJs/V3Y9EBKRLSKpWB72zwjCV+b/1pouEzHObduGDdfYOCjJ19Q
         WPwQSenaurTwFDK+DxixUaGyWC28ORyipmMW8u3pia+rhKzj/iWNQLV7YtAS54k57mca
         MR2Y85r/UCeYnYCyABkihAKkrtFWfD9WgX1N5JE8I0wZjAxCOaWrk+qRhW+0Ujbj98Lk
         xr/NP/kjMq+WqMhtO1cK32v3eixjOuvogDLReoKfz4nccweszvpObTg6I7fc5Mh0L42e
         NeoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679846236;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzwnjkUenmiZUEBZjCVaStCmhFT11zV1dVjxIZMZJd0=;
        b=LZzaukPAMV31W6CWLhMB26FBWfnL00i8LC4FNhIjZCYAGXMwV1zkPzu7Uw5cTIxAvQ
         W0+oFumDvTdJZ/CDBL/OyuswTPbzd5BazmgiHN21NJZUyBBUTHWoPhzhWkbGUOhZHtOB
         AL/x+keV0pZetEJEeaM2MMEfKoVZa2H3Pjg22onKeZ6J1yicIcC/6A9cIscfbZtuWEMV
         Qq87arjvOvfn9hEZQ5+PH7fqdTu2ID3FKJWUhutTPsievTTdh637bGTqKQ/qyxWlb5Co
         +9W2QynR38niObqs+a2u4ZrSfJ7JeOoW8OSZeeE6GeNh3//VKQH/9FasQGtLspSWOcnP
         fE3g==
X-Gm-Message-State: AAQBX9eqs0gwEkjUnGUYY2ZH3RtkMusapfFjLiQQJoHKMVNVfv/L/eLA
        wjNg35Szl8zu4GGKUBtpCoHUpryWf6pDGGVzsNE=
X-Google-Smtp-Source: AKy350YsHlytX1VVCSJekSF2Z1TcLyMip/EYWzfminCAphE8YgD9KcDzJVhUuSsiodWiw06LGwZ5wc1zYXlnd9GS1Eg=
X-Received: by 2002:a17:903:22cb:b0:19a:850a:d88b with SMTP id
 y11-20020a17090322cb00b0019a850ad88bmr3353832plg.4.1679846236663; Sun, 26 Mar
 2023 08:57:16 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:e98a:b0:60:784c:95a4 with HTTP; Sun, 26 Mar 2023
 08:57:16 -0700 (PDT)
Reply-To: mr.alabbashadi@gmail.com
From:   "mr.alabbas hadi" <nutritionf65@gmail.com>
Date:   Sun, 26 Mar 2023 08:57:16 -0700
Message-ID: <CANLmhrWj-XbQ+OTpowXhHiWZcztERYuXUXMeb56=hUXu+275hA@mail.gmail.com>
Subject: WITH ALL DUE RESPECT,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-- 
Greetings,

I have a Mutual/Beneficial Business Project that would be beneficial
to you. I only have two questions to ask of you, if you are
interested.

 1. Can you handle this project?
 2. Can I give you this trust?

It's legal and no risk involved, I will send you more details as soon
as I hear from you.

Thanks
