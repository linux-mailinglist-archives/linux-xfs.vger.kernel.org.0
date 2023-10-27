Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1887D9BC0
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 16:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345558AbjJ0OmI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 Oct 2023 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbjJ0OmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2023 10:42:07 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B0BD7
        for <linux-xfs@vger.kernel.org>; Fri, 27 Oct 2023 07:42:05 -0700 (PDT)
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1qwO2E-003Dpv-MQ; Fri, 27 Oct 2023 14:42:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#1054644: xfsprogs-udeb: causes D-I to fail, reporting errors about missing partition devices
Reply-To: Bastian Germann <bage@debian.org>, 1054644@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 1054644
X-Debian-PR-Package: xfsprogs-udeb
X-Debian-PR-Keywords: 
References: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com> <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
X-Debian-PR-Source: xfsprogs
Received: via spool by 1054644-submit@bugs.debian.org id=B1054644.1698417569767411
          (code B ref 1054644); Fri, 27 Oct 2023 14:42:01 +0000
Received: (at 1054644) by bugs.debian.org; 27 Oct 2023 14:39:29 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Bayes: score:0.0000 Tokens: new, 17; hammy, 121; neutral, 25; spammy,
        0. spammytokens:
        hammytokens:0.000-+--Hx-spam-relays-external:sk:stravin,
        0.000-+--H*RT:sk:stravin, 0.000-+--Hx-spam-relays-external:311,
        0.000-+--H*RT:311, 0.000-+--H*RT:108
Received: from stravinsky.debian.org ([2001:41b8:202:deb::311:108]:56564)
        from C=NA,ST=NA,L=Ankh Morpork,O=Debian SMTP,OU=Debian SMTP CA,CN=stravinsky.debian.org,EMAIL=hostmaster@stravinsky.debian.org (verified)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1qwNzl-003Dd7-Dz
        for 1054644@bugs.debian.org; Fri, 27 Oct 2023 14:39:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:Reply-To
        :Cc:Content-ID:Content-Description;
        bh=aki5NUDMxRSYYnCitm2l2ZADpCTLWZ+czw+8MEoKAWY=; b=eDH0RMhSst69UdKGNGrFqfQBxn
        SG8Qt4nSBTqwMobKjIflCSZ3Cn3psuo4pB8y1+RtnIk/oBKegWy05HETJxNARoXqd9LgVco8zlphK
        DE94Lqoh1yU9PvIo5+y/W1y/T4srRu4ui7Dij5OFcJdeE7RkKnMjcBqlBC/gCKloU4qWzgalF6dXk
        /Iu1e91MmsJ2hc6EubmB5pbfZdXX8t8VBs5f5BKSSYftgrMFWHue4FC0qjIhhknd6dp2knJ0sYlB+
        AogCqNfpr9wj/tOU0GPoD/I37QTqnPmf//zVMuNR95hQ4V0y2IG/XFXn7Gu7DMARZe3lrJWyt2LT3
        TYcbPT+Q==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1qwNzi-000JRo-2c; Fri, 27 Oct 2023 14:39:26 +0000
Message-ID: <83480c9f-6da0-40d7-8ae5-5cd8f0120ead@debian.org>
Date:   Fri, 27 Oct 2023 16:39:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: de-DE
To:     Philip Hands <phil@hands.com>, 1054644@bugs.debian.org
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <169839498168.1174073.11485737048739628391.reportbug@nimble.hk.hands.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: bage
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Phil,

Am 27.10.23 um 10:23 schrieb Philip Hands:
> Could this be related to #1051543?
> 
> I'll try testing D-I while using the patch from that bug, to see if that helps.

Okay. I am going to wait for more info from you. If that does not help,
can you please explain which of xfsprogs-udeb's programs are used that lead to the fail?

Thanks for the report,
Bastian
