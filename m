Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407A6270B19
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Sep 2020 08:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISG3q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Sep 2020 02:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgISG3q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Sep 2020 02:29:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665DAC0613CE
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 23:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8jLnFJEbr4zjHJu2eraGaHDjzmGUQBzz2kb5EHSPf/E=; b=qxW5TaiftlgCX4cZr1jloYsjQ+
        vZYHUtXA6OlUWeT1arL+F7NVd7pka2BiaSuLcXrXCUuaA9+nNDKDmAYnsVccpo/CsIcVTH5YAjbVJ
        IamSTWSyj3jC3qnZGrqj4fs/rxkTAIof+MhSmCQzyK6H9EJU3qqael4YwGk2bOetwrAWY8Wlk3BLH
        FKPiaGllZUFONRlI1IZMHmW2L2uM2VZPBJpuDyDeYC6UBwlAm/ivv1BOmbIdMD5yGxzjYUFeE5OOe
        PHdfxnDVrrC0H+IFYaQcSZVFO+sdGOp5/uVdhaXuwToHYpmftG4mkL0tSN3k98uQDTqa7Ef+yAiLK
        imBTpzHQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJWNL-0003jX-2p; Sat, 19 Sep 2020 06:29:35 +0000
Date:   Sat, 19 Sep 2020 07:29:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     xiakaixu1987@gmail.com
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH v2 6/7] xfs: code cleanup in
 xfs_attr_leaf_entsize_{remote,local}
Message-ID: <20200919062935.GD13501@infradead.org>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600342728-21149-7-git-send-email-kaixuxia@tencent.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 07:38:47PM +0800, xiakaixu1987@gmail.com wrote:
>  static inline int xfs_attr_leaf_entsize_local(int nlen, int vlen)
>  {
> -	return ((uint)sizeof(xfs_attr_leaf_name_local_t) - 1 + (nlen) + (vlen) +
> -		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
> +	return round_up(sizeof(struct xfs_attr_leaf_name_local) - 1 + nlen + vlen,

Please avoid the overly long line here.
