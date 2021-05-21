Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8338C0C5
	for <lists+linux-xfs@lfdr.de>; Fri, 21 May 2021 09:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236085AbhEUHct (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 May 2021 03:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236076AbhEUHcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 May 2021 03:32:47 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A36DC0613ED
        for <linux-xfs@vger.kernel.org>; Fri, 21 May 2021 00:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=rZELGo9nCM6Yg8EhJ5TbGjoD1d
        AuUux1ogXwe8mWjeXS+/6PBTCpm3kAFMd83vllpO3FEGpql6rtv7ZlJbxYc7cxi1dgicG231a6/dN
        1MkegS3dOSZZXIfqcXhHLPKNqd72iPdckFFWZBJebhunhjkNRifVTj9wdakhDTLsVL93lUpMNvswx
        91/smPA06bLKDW43Uu8E6/qoCt6SOzboafmRWrLPegQiBX0RHmAZDhuYhYBGIYs29v1+ZCn+7Tz3e
        geenzrbEq/ZaojXQhB1Vy4Dgbh/VlFCBixDIiQ6fLuUGoG+l2/DqzkhtzmW2yMQN7g4C5rb6wissN
        8t0vJqnw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljzbM-00Gkgg-AJ; Fri, 21 May 2021 07:30:10 +0000
Date:   Fri, 21 May 2021 08:29:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: standardize extent size hint validation
Message-ID: <YKdhaCwiGXD72ClY@infradead.org>
References: <162152893588.2694219.2462663047828018294.stgit@magnolia>
 <162152894168.2694219.4445220721253692769.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162152894168.2694219.4445220721253692769.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
