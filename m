Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A45AE70A
	for <lists+linux-xfs@lfdr.de>; Tue,  6 Sep 2022 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbiIFL7Z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 6 Sep 2022 07:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiIFL7Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Sep 2022 07:59:24 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC3FC43
        for <linux-xfs@vger.kernel.org>; Tue,  6 Sep 2022 04:59:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id qh18so22639372ejb.7
        for <linux-xfs@vger.kernel.org>; Tue, 06 Sep 2022 04:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=QX/1FO7BJ13W8Bio4Hvphp1pk6RLZuW1D+bYVy4ZDhE=;
        b=b6/4Rn16tV7e5zxsRBKRwfxaqtoejfR0li/cXO/t4EE9Ji12ydEALEzU2frN8D/q3S
         MhHjPXCo8Bfs2eR0alOuHN5n4Pi3o4sXd/IEKk48G1Omob9rULAcvzPdZ8gvDL+Mx8Q2
         3Irc0awK/Y8snKTUlruL0FB6vku83mV2CWsLkoslsMPAIsf/Pf6XicqheQo0pID31gut
         xZf616wMbNMqoPS8vE9p19RxWiNZRdlLs4+fy1YpQ0WsMMCqJagmbXqNVSZoNQfiGrka
         8NcKBMmN7q+74cjL7CO5TVkSg9tunaqsSYJeOGfTCCVXdz5FDw+2sEB0SP7/oz0fXU8a
         iGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=QX/1FO7BJ13W8Bio4Hvphp1pk6RLZuW1D+bYVy4ZDhE=;
        b=Gu/Cjc72hgRwGH7u9iM2gJIUIKkm7cK5K9SfCQj6e1R/Vo5mtb1N0DB1FUQQM4m87V
         ZKyBUD51Hne8LeM81JMa4sT2rSUmiiQiiD+129q8s86aH6FviLh4hJYHQGRnT6FyJfsw
         hji94ZJpsiIw3Gpeps/PIyr6Ai+N0hfwFb16nVKKc+aE2A3H8JWHhVtJg1Kbs9wY9AMq
         duXkj6J0Pr7FxLE94lQ9eGK7/8Zxcb25D7EdJDrGAjXKo1x6EG2somb4VLNYnAVbDQkK
         54+qZ9orkM/RVLpcVo3ZGTS23jhrTCuptO3SKpFwf8kkP/Ls+vwkp7SZbPQEtuhb2fN2
         hB6Q==
X-Gm-Message-State: ACgBeo1tN9MKGeFONT4jCVsew3+t/3f/v/zx3FgSxoQWR72AeAPrOs7Q
        PpPmFBHtVZDeqpOVROivB7tF5uqpqC5nxQgfCN/N58Qhyk4=
X-Google-Smtp-Source: AA6agR52fkrXR9vsigsmSh9lzMlyLi/IzdvYaiPJQa4OSSQmoUtI6GiUuiHSROhtG8ZJHyN7m1qWVdx98udqIgtoG3U=
X-Received: by 2002:a17:906:65c6:b0:73c:8897:65b0 with SMTP id
 z6-20020a17090665c600b0073c889765b0mr39240187ejn.322.1662465561567; Tue, 06
 Sep 2022 04:59:21 -0700 (PDT)
MIME-Version: 1.0
From:   JunChao Sun <sunjunchao2870@gmail.com>
Date:   Tue, 6 Sep 2022 19:59:09 +0800
Message-ID: <CAHB1Nai8Ux+7DWr89EOdRcwWLxg82iFnNgv6=cP32qiw36wyzA@mail.gmail.com>
Subject: 
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

unsubscribe linux-xfs
