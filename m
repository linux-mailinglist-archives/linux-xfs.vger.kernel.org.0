Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35B44FF006
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Apr 2022 08:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiDMGo0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Apr 2022 02:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiDMGoZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 02:44:25 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00462C11C
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 23:42:05 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r13so1921444ejd.5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=QX/1FO7BJ13W8Bio4Hvphp1pk6RLZuW1D+bYVy4ZDhE=;
        b=EaNNNwjvIikpu0NncNg8x9TMIeBIG34OHfquW4PEe6dFbTyXsQG3ES/22AS97VEVaN
         0hZyFFbBl2rteuBwyYmlkIj989wlVmMrxpdp+CzfNlT2a0/Owf9L0uwFW/MW3NzLvvjn
         uwe55Oi62Td1AQiM/ejgpLWyUn4aWaMiC+PSoxjTqbWPzhDUkMHT2Dx8QYyg1qew5bhk
         uDhrMc3AseKySol+PlVAfYbuSphhXBmZmyYn4BUbG5yexMBXreFUfvMJQX5NoS2dxsVY
         8UgbGp2osqJ7E79Julit8kyTS9msuagsncwEingckG2JQVp+Kc380Enydhc85sp737QZ
         AL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QX/1FO7BJ13W8Bio4Hvphp1pk6RLZuW1D+bYVy4ZDhE=;
        b=7IbS8MU9FkbYdTeUvph8V+bql23c42iJ8TDRBwbrcv0fnjrCTm1fQaEKXyqTxnhQUe
         qUYSFoPIGCGfKBQxXTrtahkbv/hFplez8pq/5LInXm9ZR01ids66No8O2oqSx9byw+y9
         Kw0McSBudvP+vyFHlR2gPfxWgxuRmfH8DEHHBJskaIKmUBRUV3tDYNemzF//bz2sIvC0
         +iqo+no+IAaIXGB3ZvNJTOExlGs9btqiAjBcneK9oCt5XXwTc7Z+GeRJfb4Y1i4lEGFE
         +CxQUwN0hNfaZaOuVzbzBQEERQo8u1NGEsO+AyzMdPjLl12mQgs6VQa5GMyEf56Xm6p0
         ZXuw==
X-Gm-Message-State: AOAM53182bwcojogHD6TenoWdHvxWOgb2ddT+NK7Si+EjfQgGCaH9hzK
        KMs9Bp0hPnjAHlwKx38ibVDFqG2rGYeseTr+4uO53+aB
X-Google-Smtp-Source: ABdhPJyGWkuBYsBFg2fHK1BO3p5y4Jn2Um3EWKFG84c2MxjRaCHMnjxmi21M0WYHd55BzXx8Dfz5ZvOczqPfiUSHgfU=
X-Received: by 2002:a17:907:724a:b0:6e8:4f12:b6fd with SMTP id
 ds10-20020a170907724a00b006e84f12b6fdmr21368033ejc.198.1649832123773; Tue, 12
 Apr 2022 23:42:03 -0700 (PDT)
MIME-Version: 1.0
From:   zgur ETH <ozgur.root@gmail.com>
Date:   Wed, 13 Apr 2022 10:41:52 +0400
Message-ID: <CAC2PxVMhMSZTfRg=4jPoibHN-FQRkPDi3Mw41P=6_W_8YRy-vw@mail.gmail.com>
Subject: 
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

unsubscribe linux-xfs
