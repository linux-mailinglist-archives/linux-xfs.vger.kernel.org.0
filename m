Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2317C59F
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2020 19:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCFSpF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Mar 2020 13:45:05 -0500
Received: from buxtehude.debian.org ([209.87.16.39]:42996 "EHLO
        buxtehude.debian.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgCFSpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Mar 2020 13:45:05 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 13:45:04 EST
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1jAHy2-0004nD-UZ; Fri, 06 Mar 2020 18:45:02 +0000
X-Loop: owner@bugs.debian.org
Subject: Bug#695875: Build with libedit rather than libreadline5
Reply-To: Bastian Germann <bastiangermann@fishpost.de>,
          695875@bugs.debian.org
X-Loop: owner@bugs.debian.org
X-Debian-PR-Message: followup 695875
X-Debian-PR-Package: xfsprogs
X-Debian-PR-Keywords: patch
References: <20121213212730.25675.16201.reportbug@localhost>
X-Debian-PR-Source: xfsprogs
Received: via spool by 695875-submit@bugs.debian.org id=B695875.158352006316682
          (code B ref 695875); Fri, 06 Mar 2020 18:45:02 +0000
Received: (at 695875) by bugs.debian.org; 6 Mar 2020 18:41:03 +0000
X-Spam-Checker-Version: SpamAssassin 3.4.2-bugs.debian.org_2005_01_02
        (2018-09-13) on buxtehude.debian.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=4.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,TXREP
        autolearn=ham autolearn_force=no
        version=3.4.2-bugs.debian.org_2005_01_02
X-Spam-Bayes: score:0.0000 Tokens: new, 14; hammy, 108; neutral, 22; spammy,
        0. spammytokens: hammytokens:0.000-+--H*r:TLS1_3, 0.000-+--H*u:68.0,
        0.000-+--sk:libread, 0.000-+--builddepend, 0.000-+--build-depend
Received: from mail-wm1-x329.google.com ([2a00:1450:4864:20::329]:35582)
        by buxtehude.debian.org with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <bastiangermann@fishpost.de>)
        id 1jAHuA-0004Km-Uq
        for 695875@bugs.debian.org; Fri, 06 Mar 2020 18:41:03 +0000
Received: by mail-wm1-x329.google.com with SMTP id m3so3443567wmi.0
        for <695875@bugs.debian.org>; Fri, 06 Mar 2020 10:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fishpost-de.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=sxqK7aklJt1I8I40+SPWFCL7MwHIQFI+NrHeVsF7Y8E=;
        b=DrbO37AUWxyAOXyBGOfxoKILQAagIAOjbS8cIuG2FctvbLk9Wss0k5TgXE1AHNgrvt
         BtoqwEcw1GtK0TIcgeMnnvlua23J1mnEy/Bf5JA1jQ9nqgK8g+kffS7pXpmurrLavQW/
         5xyLqFISGDqpab16nJqvbZl1YY+YqFPCWgKZ4yTh52sPPkUOq0eb7eYMw7Qmfe8bQA6W
         nzHtXHyQFEyHV4PNXarwmH6wFl74wYBJcOLaFWTDt7qajVf9IUstNRfFjRrpNPjpBcxF
         RibPqjz/88PHDL0b0rU7BT49iKCVT9LgKzn6IkVizmRATjkAscuzqTmCv+5gkH1wYArT
         Cx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=sxqK7aklJt1I8I40+SPWFCL7MwHIQFI+NrHeVsF7Y8E=;
        b=CjMqCQ58DoO6k5OgsX+svJvKNMyqiPrdZOnoNYhzX4tuSGT0BNVKCRffRINlBwTDBb
         9F+TiGmn7T0cpWU9kiPyZPx9K2al2HRSB7DgKZ3g+Nd6nMpcBxzaRCPckdlMebbuJ0FK
         mzoRQQ8fH4f9raNr+dqzZkB8GfQAix4ZhIlkCsGAXCE9puafACG5AKJSV3L9K8b/n+i5
         GceNlGrf0IbxVhLtLGlmsW8Ba9o4kxxg7e1Mie3VROTtW/q9Bc/2L+P2KJJG3AxDrcC+
         +ROCwuzS4oC2WAGqBn7ujSl2njwlBn0yvcfi3hnrAyaqaPtMvNf1q0MkmtoQOffgzfXk
         ho5A==
X-Gm-Message-State: ANhLgQ3GcquHQ79KYm0Nwr+sgXDdcVttRD4faprwQu5Co6iViS1LJDGC
        Pl1Fpz4xyd/zrkKfynSOoUhSJ3IpXa4=
X-Google-Smtp-Source: ADFU+vtvu34v59OQsslWELlJqXSgyLFSCCV6fOW2Cw6fAT7Up9bYLyQoB2CRRMaL/WkjS0Jd/Wm6RA==
X-Received: by 2002:a1c:960c:: with SMTP id y12mr5227435wmd.9.1583520059853;
        Fri, 06 Mar 2020 10:40:59 -0800 (PST)
Received: from [192.168.178.68] (dslb-084-059-208-037.084.059.pools.vodafone-ip.de. [84.59.208.37])
        by smtp.gmail.com with ESMTPSA id n24sm9198178wra.61.2020.03.06.10.40.59
        for <695875@bugs.debian.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 10:40:59 -0800 (PST)
To:     695875@bugs.debian.org
From:   Bastian Germann <bastiangermann@fishpost.de>
Message-ID: <790bc229-14bb-fb31-2242-d430db5add24@fishpost.de>
Date:   Fri, 6 Mar 2020 19:40:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Please let the package build-depend on libedit-dev rather than the
orphaned libreadline-gplv2-dev. It is supported by upstream and its
license is compatible.

The configure option --enable-readline=yes would have to be changed to
--enable-editline=yes.
