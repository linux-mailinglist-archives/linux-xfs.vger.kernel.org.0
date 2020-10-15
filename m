Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2332C28EE99
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgJOIgD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgJOIgC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:36:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB5FC061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=lNr/qtJ8c8pNNog0IetuEMP0oH
        2yiclpPJosOso5XFSmnRDyVbdophwdTNG/DFLOW/G4YYDkArOxB3jwE7GOeG4NSbRhA/rwqO8264/
        IIU1zAVcXUpzaI7BRk06l6Z1KEBbEyj20UTLzhUifp9/aOG7kVcoq+B7rpy5vzeG6XnpWGSJb3MlG
        NyrJJ8O9+c0dMkrv1eTdclM+WNmXe2f6XN7z1YSVMEYjzK64OFC0nxal07D8cQUxvHufgv7kWOGgX
        jKifDJANGUVt8uvX1pAwgo9P/bbvqdENBLn39lsos+jf1gsaKNoWq9xB4vfm/GugqqTqy3PcfQlKH
        +XT3gimw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSyjx-0001pv-Er; Thu, 15 Oct 2020 08:36:01 +0000
Date:   Thu, 15 Oct 2020 09:36:01 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 04/11] xfs: Check for extent overflow when
 adding/removing xattrs
Message-ID: <20201015083601.GD5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-5-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-5-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
