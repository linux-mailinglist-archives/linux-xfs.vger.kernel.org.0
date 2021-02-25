Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B51324BED
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhBYIVQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 03:21:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235669AbhBYIVO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:21:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD5EC061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:20:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=uTqQHKA2ris0DQV01QFxYam3ZI
        rdeqJE8/2oUrTJBXupv0ftJUGTK0WNWrQ5FZ6Jk/v/KaeuxD6jm2brvrBvO2837J/HYrxZvW/ner9
        LIv735TDg6SAUVYplhtRIvG4TwfkacEaJhKhrQpYjD0tjEC42H/cfGF2jKRrJ/0ePUQPJcVILZ5uW
        ttotAL8IIchi8YKrnJDvWYrz0GiT3OPqSRvlrthLvKBWVr+zDlMHaSRoou7qxLq214niTlEQJ0PHx
        flO/qu8/2OV1FPTk9qeLWD8mrgKc6LFyGvWkrXRbOlR4okODBq5Fi5FKSQJKvCmL0Gs2RcjSM6kjm
        qT5QQSrQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBsB-00ASSb-2H; Thu, 25 Feb 2021 08:19:54 +0000
Date:   Thu, 25 Feb 2021 08:19:47 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs_repair: add post-phase error injection points
Message-ID: <20210225081947.GO2483198@infradead.org>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404928343.425602.4302650863642276667.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404928343.425602.4302650863642276667.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
