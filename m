Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA42FED42C
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Nov 2019 19:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbfKCSYw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 3 Nov 2019 13:24:52 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33673 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfKCSYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 13:24:51 -0500
Received: by mail-wr1-f52.google.com with SMTP id s1so14622040wro.0
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 10:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=message-id:from:to:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=eDESwIm7SxTXy99Q+vBsmy2HEFXAakVo2xyzKPkBw6w=;
        b=Sa8N5BGWxUpwKRbilBI+sl0PFWQiZn/FhnKq8zZJNa7VTSt9JI0bXznaQDh9n55kCA
         2Bu4xVkTj1QC6EsxZ+E4yNRH4EZbApePX+XtP3j+RPOzL9pI4rsYb7isiWNC1Q9sxjVK
         D+VlSLDdLQa+yJS6hxSgh/ndkf4uAKKuQ1eSn474VPFX1GQJHq05R9ffCX4v0hP+BW/7
         03wZLn3v/tausn+cj0w6uJ05KQGgjhu3M7aFrdcFASbWo3yAaCu1t1v7WSaBwg51mC2N
         7MN5pthvuatntJd71BO/lP3yCGKNiswgqnaPWu1zzd7BlZDU3+LCOmjmAAa3I6QZR62E
         k2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:from:to:subject:date:mime-version
         :content-transfer-encoding:importance;
        bh=eDESwIm7SxTXy99Q+vBsmy2HEFXAakVo2xyzKPkBw6w=;
        b=rnHwFaqZUOWabcn4QoIt5cx0WHAS1S+uSpmTFtDeaj026aWKiAMHUEn1HDs7LPAuwR
         f8YiJTDYRK+AuNmXYhjBDQ7/uGQEx30EkpACCmhkZUH2ct2lz85/ovwr/pOvFzZTLJfy
         i/nUJ2YDZ98piNm7HHEChCCPE9NN9/NNtOmzJ6rCuy/PNm4N22e8ewEkYlSERJX1UW7c
         KdytjicwjjBHeHR33kDK1o83C+/HJCH3erFMff1FOhwKsBBMGJHv9vrwzV5DpdFQHd81
         uqPv1IsJyUnScKx2oAaLECpK6tEGLrs/3+HBFqIOfjW0Ucrj7AHDRBPmdCFdf/MHNOGR
         CRXw==
X-Gm-Message-State: APjAAAUDc6lxBo6UTB5NTVio5CPcIoTM544ZrG5IxTjbHYISyAvSRcI2
        KoPXVK2dgzHy33UYws15zMRUc89H0nI=
X-Google-Smtp-Source: APXvYqxsli1fu6X3iLiCLUCMQj8cJgN8BkspBvsCmmGTX5bVBCOx4vQcVWVoVILbjJeeSQ2MtSqbdw==
X-Received: by 2002:a5d:46d2:: with SMTP id g18mr19137284wrs.245.1572805489503;
        Sun, 03 Nov 2019 10:24:49 -0800 (PST)
Received: from alyakaslap ([82.166.81.77])
        by smtp.gmail.com with ESMTPSA id j15sm14927027wrt.78.2019.11.03.10.24.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Nov 2019 10:24:48 -0800 (PST)
Message-ID: <CAE4254A1B4C4A2895049EE040022942@alyakaslap>
From:   "Alex Lyakas" <alex@zadara.com>
To:     <david@fromorbit.com>, <linux-xfs@vger.kernel.org>
Subject: xfs_buf_rele(): xfs: fix use-after-free race in xfs_buf_rele
Date:   Sun, 3 Nov 2019 20:24:21 +0200
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

This commit
[37fd1678245f7a5898c1b05128bc481fb403c290 xfs: fix use-after-free race in 
xfs_buf_rele]
fixes a use-after-free issue.

We are looking at XFS buffer cache + LRU code in kernel 4.14, while the 
above fix arrived in kernel 4.19. Do you think this fix should be backported 
to stable kernels?

Thanks,
Alex.

