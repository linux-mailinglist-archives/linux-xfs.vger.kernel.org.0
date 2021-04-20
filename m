Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB847365251
	for <lists+linux-xfs@lfdr.de>; Tue, 20 Apr 2021 08:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhDTGXd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 20 Apr 2021 02:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhDTGXc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Apr 2021 02:23:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4EDC06174A;
        Mon, 19 Apr 2021 23:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=j3to8PsROm0Af0SVNpXncr0h9H
        sbBMhJVsvABkeai1Wz2mzHI9Vv4+P0cazCpLjAjkYp+urtfDB67jSTDNlPZjO9VxTjsHK1pKCvrSo
        CCjy/sYKsx+dCBNUQJ7qXvezGRuZaYQnl8NCYlnflEMzS91FcD/oWSDc/8sJxSR0VW8+14Ha/IqYV
        +WKIJScal6rN5gge4H1FkyCvphMdk18uUtf6zijQwlHWPar+yKpXF+yKcJPUF+A/6/hSJjAp/dLU3
        UaY2sRTZ1Oel0e4L8i/+NQGudeWA1xHO011cntg9IE9fXZxx0vKBKGFeJwOFowZUQZaMK/Y3zfiM9
        /5Dld15Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYjln-00EngT-LW; Tue, 20 Apr 2021 06:22:26 +0000
Date:   Tue, 20 Apr 2021 07:21:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 9/9] xfs/305: make sure that fsstress is still running
 when we quotaoff
Message-ID: <20210420062159.GA3525612@infradead.org>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
 <161836232608.2754991.16417283237743979525.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836232608.2754991.16417283237743979525.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
