Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E731514A930
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jan 2020 18:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgA0RnF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jan 2020 12:43:05 -0500
Received: from sandeen.net ([63.231.237.45]:54016 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0RnE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Jan 2020 12:43:04 -0500
Received: from Lucys-MacBook-Air.local (erlite [10.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BDAD65EDAD;
        Mon, 27 Jan 2020 11:43:03 -0600 (CST)
Subject: Re: [PATCH] xfsprogs: don't warn about packed members
To:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <20191216215245.13666-1-david@fromorbit.com>
 <20200126110212.GA23829@infradead.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <029fa407-6bf5-c8c0-450a-25bded280fec@sandeen.net>
Date:   Mon, 27 Jan 2020 11:43:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200126110212.GA23829@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/26/20 5:02 AM, Christoph Hellwig wrote:
> Eric, can you pick this one up?  The warnings are fairly annoying..
> 

Sorry, I had missed this one and/or the feedback on the original patch
wasn't resolved.  I tend to agree that turning off the warning globally
because we know /this/ one is OK seems somewhat suboptimal.

Let me take a look again.

-Eric
