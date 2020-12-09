Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D802D488C
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Dec 2020 19:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgLISEr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Dec 2020 13:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgLISEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 13:04:46 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B430EC0613CF
        for <linux-xfs@vger.kernel.org>; Wed,  9 Dec 2020 10:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OmffREOfdHFSkBilDlmRAzA5dTUVMkhzR4/DIPoisCE=; b=GeZwvbyQ8rDr1wZUY1zfkCLSNZ
        ytD2AKdeWCptFoRtLAL0N8p35F5hariKBz+jlVQ36AtxKIS7j/K7qn4AmuEsWbFo4bXfxdVBUwRhA
        zR7sr8n/pyOo9V+xgmWfpzaxVHv2A5MkzZc6JjVpEcOUnvhc3tKIY+iuyVSgy1Kx7apWl47ANvnX9
        WzhGrVOb7iomAPuyTcGd86Dq/Wa2ohfW3BjsWgdE9K6rWiz56ygOsSG7fe8M/WBaDazsSz88GjPNj
        hCc9VFryA5Q6yZdAqzutgRCzoryaE3K67B3vRI4HIM0H5tJ+FmHYkpkFkJNiavI7oPOFoorSi5B+M
        zkmR/rOQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3om-0007RF-Lb; Wed, 09 Dec 2020 18:04:00 +0000
Date:   Wed, 9 Dec 2020 18:04:00 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, bfoster@redhat.com, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: define a new "needrepair" feature
Message-ID: <20201209180400.GB28047@infradead.org>
References: <160729616025.1606994.13590463307385382944.stgit@magnolia>
 <160729617344.1606994.3329458995178500981.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729617344.1606994.3329458995178500981.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Who is going to set this flag?  If the kernel ever sets it that is
a good way to totally brick systems if it happens on the root file
system.
