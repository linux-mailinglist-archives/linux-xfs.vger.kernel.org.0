Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD293E4805
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Aug 2021 16:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhHIOyv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Aug 2021 10:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234723AbhHIOyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Aug 2021 10:54:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C66C0613D3
        for <linux-xfs@vger.kernel.org>; Mon,  9 Aug 2021 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ZXq3u09tnD7nMQVocVkw9tG1dB
        CfAJ7TWRvRoC6KH4HNQPHdksBqRa5PtVEf9PTe7Mk01Z+M+P2t+7Gfru4pCKOj5UxGVcmdof6QwWm
        9NkwKANF8nCmuPzlUN5/BjkMw4rQ7EtkunEMAoLS7Rczxm7skQE8Ubf1C0d8LTLkj638szINdSSZd
        rpu+fRMTf/NSvzPTeuMqqMTmsnFQxQS6bhFzh1IAJ20vdNyJSVTashIUZzR/6DXiucbh62DqyrtmZ
        +Rd81WH6RQKbMHCJoNPsrqX9EI44ZUxctHSsxjOTR3/rt4kJTDQAKf2ArSr3slxdzpQjdAQDoGQmq
        PM/kFd8g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mD6eb-00B5nv-BE; Mon, 09 Aug 2021 14:53:49 +0000
Date:   Mon, 9 Aug 2021 15:53:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: drop experimental warnings for bigtime and
 inobtcount
Message-ID: <YRFBZdLbCZN6mHkf@infradead.org>
References: <162814684332.2777088.14593133806068529811.stgit@magnolia>
 <162814685444.2777088.14865867141337716049.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162814685444.2777088.14865867141337716049.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
