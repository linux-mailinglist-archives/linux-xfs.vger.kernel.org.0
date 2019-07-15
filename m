Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F8569869
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 17:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbfGOPht (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 11:37:49 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbfGOPhs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 11:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Dpwp+TH7k6zAs/WPihUO+dAwt8Pi/Ve3wjju0qlNq9k=; b=Ola51y71pLvr9ZMpxS3ApRdVa
        rhIDIgPCKv2vMwqFNrfBF1G+nZeHEyLAHp+I9rB/yjKpHCGx5s7ScP6VgzG4SmSQVQxlfXrMT56l3
        /JIAb9ckBjpxKwfP6agh2lPsM0n/FUYa/tdl8D0hfjkTPVjHcQZGmkYOPvmRjkpC8oNK+6uHTIKh8
        L0QFq0AuZSXvO7WQVSZ/zYVw1GwQ29ReZWV64kSYJp+LgczTKTWMO+vh+otMzKrFV1/z6+ibHtt9s
        eEJTLUY2nwgPp49NtvmsAbkWCjq2Lpgo0TBUndLWq/dEwf8TqST7IUQrV+qTxO6cWCph96YVbnXY+
        MBpXtyeLw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hn32x-0007pb-In; Mon, 15 Jul 2019 15:37:47 +0000
Date:   Mon, 15 Jul 2019 08:37:47 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org, darrick.wong@oracle.com,
        linux-xfs@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH v8] Documentation: filesystem: Convert xfs.txt to ReST
Message-ID: <20190715153747.GB32320@bombadil.infradead.org>
References: <20190714125831.GA19200@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714125831.GA19200@localhost>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 14, 2019 at 01:58:31PM +0100, Sheriff Esseson wrote:
> Move xfs.txt to admin-guide, convert xfs.txt to ReST and broken references
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
