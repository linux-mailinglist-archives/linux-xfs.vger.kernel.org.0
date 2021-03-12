Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF35D338EB0
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Mar 2021 14:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhCLNYI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Mar 2021 08:24:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhCLNXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Mar 2021 08:23:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615555421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eqk2ewTMtmrT8wZQr3P/BizmB1Yzno25N3/VZwVg/1Q=;
        b=EzqMzcp9wYy15qcI2YNug65aaBArLC+5zgw1X9s3+xd1H3N6yW41lsplOSX/Q0Oe9hMwyh
        Evp7s7wQWZHcpwuWHC4iK28T0q9mj9Eq2ck+IMji42yTsG5WR726Gw7yiGZfIy9T3H0rKE
        o5do10K8HZOswWxVMkoQsvvETYQ1lIc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-pOQiPE4OOSmnFlE2TIvBRA-1; Fri, 12 Mar 2021 08:23:40 -0500
X-MC-Unique: pOQiPE4OOSmnFlE2TIvBRA-1
Received: by mail-pg1-f199.google.com with SMTP id h16so13258180pgv.4
        for <linux-xfs@vger.kernel.org>; Fri, 12 Mar 2021 05:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eqk2ewTMtmrT8wZQr3P/BizmB1Yzno25N3/VZwVg/1Q=;
        b=g3bfFS5w8Ht/Vtdm2fC/sGY/jjZZmCvc/daybv/VcHhb2hogt3SJ0OEOsNFJn3Q/qS
         E1Ux/XzHvbylT8ALkPHiTcMi1//NYV0GTfeB6158uzjjbCk+2G2HB3SBZLmNV/9T13oX
         h3NLMh9l4kxUyqTrdCnYRLkVrDOYOlTx74BdroxYKkgOy9yemOJLWvwyofm45Kb6/8/L
         Id5PkzvMcGiBqbmRynItSn0k9YPpK4F3QXvBBYqOYIvG790pQCTAiW5UgOEOvvG9rnw/
         jLDj+jo89kmMVZ11tRJ92rM0ij7+FBfeVLTvKjV2shY3moPX6RF6MavC5GlGs1ba0/49
         OorQ==
X-Gm-Message-State: AOAM530Dmqcin8Ha3cuXxzkniCEUurfMqQ47X06ZBTnwGJa5cQSNE8Xw
        KnsHENQY5WsMUnNAsS/hNxFHPWhUe6KfR9hskYJeIEY5gp+M9ibSRAEeTWbdIDtw9EGdg2P23hb
        g2e7vSFZBYwCWpYQaiyFULatF7TcqIuDRCIy8m9sgLboSlBswBz2jNRSnQyWzDRKhGTO0EqenTA
        ==
X-Received: by 2002:a17:90a:987:: with SMTP id 7mr14205729pjo.97.1615555418499;
        Fri, 12 Mar 2021 05:23:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyU4XRNXbOyhXd6AJAQKDeXogeOSSpSQD5AohNDMSDWGruMk4aq3p9MQH838EEHCdRRyEG7KA==
X-Received: by 2002:a17:90a:987:: with SMTP id 7mr14205705pjo.97.1615555418217;
        Fri, 12 Mar 2021 05:23:38 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j17sm5428234pfn.70.2021.03.12.05.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 05:23:37 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v2 0/3] xfs: testcases for shrinking free space in the last AG
Date:   Fri, 12 Mar 2021 21:22:57 +0800
Message-Id: <20210312132300.259226-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

This version matches
kernel v8: https://lore.kernel.org/r/20210305025703.3069469-1-hsiangkao@redhat.com
xfsprogs RFC: https://lore.kernel.org/r/20201028114010.545331-1-hsiangkao@redhat.com

and mainly addresses comments for the previous version.

Thanks,
Gao Xinag

changes since v1:
 - add a _require_xfs_shrink helper (Zorro, Darrick);
 - introduce a basic functionality test (Darrick);
 - drop prefix "_" for all functions in tests (Darrick);
 - introduce TIME_FACTOR and LOAD_FACTOR to adjust the load (Darrick);
 - move $decsize out of the loop (Darrick);
 - use $XFS_GROWFS_PROG instead of xfs_growfs (Darrick);
 - query the running size instead of calculating (Darrick).

 common/xfs        |  10 ++++
 tests/xfs/990     |  59 ++++++++++++++++++++++
 tests/xfs/990.out |  12 +++++
 tests/xfs/991     | 121 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/991.out |   8 +++
 tests/xfs/group   |   2 +
 6 files changed, 212 insertions(+)
 create mode 100755 tests/xfs/990
 create mode 100644 tests/xfs/990.out
 create mode 100755 tests/xfs/991
 create mode 100644 tests/xfs/991.out

-- 
2.27.0

