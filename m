Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C8C3BBEC3
	for <lists+linux-xfs@lfdr.de>; Mon,  5 Jul 2021 17:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhGEPTl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 5 Jul 2021 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbhGEPTl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 11:19:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FF0C061574
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jul 2021 08:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kNBS/mQwSCIlE/Br3vUkLieG5hq5zuSp+JeyDHmvJMY=; b=ccBkaWeZDEnpDo3N36lRXJIKCD
        0nI3pcTeqVYB6BGyJFvynUL2vAJ+4qHNHXY/4kWmUIuaUxtvqTllnpfQRP9IP5ymxaFaHCgAqxIGx
        FyDGsx8cpI+C8cFgugxFZllWl3fXR0rcPlYf9aRyE4zZCPkb8RFChVjKCJ7Ji0Trm+0Nh6dLNqxSI
        1BZzLKwd6XvoRRqIodOe9bNwDLn8++1EjxOnF0fTRkubk/3OB3EWAjh2wVA80rYNcgBe331suBpDE
        Qnrvuz91hGa6P4yK0tF4dICW/+v/ylZAYW+Am5fo+rbI8Di8vl2PxMTy9+QO1JJy2HqsBdFUdhFKQ
        /Zjn4j2w==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m0QKw-00ALr7-4J; Mon, 05 Jul 2021 15:16:50 +0000
Date:   Mon, 5 Jul 2021 16:16:42 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_io: fix broken funshare_cmd usage
Message-ID: <YOMiWq61o4GNlNAV@infradead.org>
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108265.36401.17169382978840037158.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528108265.36401.17169382978840037158.stgit@locust>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:58:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a funshare_cmd and use that to store information about the
> xfs_io funshare command instead of overwriting the contents of
> fzero_cmd.  This fixes confusing output like:
> 
> $ xfs_io -c 'fzero 2 3 --help' /
> fzero: invalid option -- '-'
> funshare off len -- unshares shared blocks within the range

Ooops, how did this manage to ever work?

Reviewed-by: Christoph Hellwig <hch@lst.de>
