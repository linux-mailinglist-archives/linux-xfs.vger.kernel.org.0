Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1E518032
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 21:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfEHTFn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 15:05:43 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44935 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfEHTFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 15:05:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id z16so10540078pgv.11
        for <linux-xfs@vger.kernel.org>; Wed, 08 May 2019 12:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xx1nBdwm/fMIaQ+XRMTVvJx4homKW8vOYVCrjJQah8c=;
        b=u2CwdPBWUhvunu491lhDVH7O10yitnzRdNYTDcNKNGaaMw+pYsmkpn0J9MsT99d39Y
         Q/Wk7PGyXcjoc1tha4UuyE89T0rOnD72kAWNnjYRKkjCa0DELX1ElQVVB5fGF3jmFGkX
         uLZw9HuRYb+PEeZ/PPFrro1K3Iw9vCnd+ELZuZL2OKCDNAb8u9QKbTbbytR8kbwE4FBI
         Zo/dlYVRRbaMO0EpBIfmHWL9EiKzdxDQc7t8r9e2EKWR9k2JLXoh6H4LfMbZMUTXsaF+
         muQoMtmzSSBP8hE/rlSXFu27Me96rPxVPBbMGgvYpGy27lg+hjZKYMbf9BMngu5WO2ck
         kXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xx1nBdwm/fMIaQ+XRMTVvJx4homKW8vOYVCrjJQah8c=;
        b=oMK0b0xSiJB5eW+9Jy4X14SuchifcTQuPA3kA2mb7Y/R6794Gq+avUy3eLUT1xOuSe
         X7+kgxOYjNmt1Xs1M2Efm3bPHOLJVDhO2PbJogDrCdCeIKABXC6NWJVaux8m+cFRzzy4
         UThqyKxYO9fHyy4YXnHCsv8TsVgs7q7Z9zMR2RM+rNXFX93m+KTjp501k9LBteEvKP92
         jtTsH2Ugb72T1TXTgmTosjl5Ila8cxVrAN0xBgoHNYrl/o4+axYeL5hqf4QEr9+yFQuU
         eSV4M6/keaaN3Gl5irVYGxfucDIoTONo0efCwNIE9Xm3fzvX6AdwHC3zRVRR6hYCTcR8
         IHmQ==
X-Gm-Message-State: APjAAAUgCYwvtiIs7fb7HjLZP3gTmIjyW8DEuuXbYHj/cpfb7ZqDMN5C
        M+kxRcb8quULSACPc+WYEO32kg==
X-Google-Smtp-Source: APXvYqzypNLQt7uc54cFtZOQcJp0DaX+ClanYsAzKwneRj68EqOnfHTAe97HizrDj+ZvHjUmPOl5NA==
X-Received: by 2002:a65:5cc8:: with SMTP id b8mr47363166pgt.36.1557342342253;
        Wed, 08 May 2019 12:05:42 -0700 (PDT)
Received: from jstaron2.mtv.corp.google.com ([2620:15c:202:201:b94f:2527:c39f:ca2d])
        by smtp.gmail.com with ESMTPSA id 129sm23470533pff.140.2019.05.08.12.05.40
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 12:05:41 -0700 (PDT)
From:   =?UTF-8?Q?Jakub_Staro=c5=84?= <jstaron@google.com>
Subject: Re: [Qemu-devel] [PATCH v7 2/6] virtio-pmem: Add virtio pmem driver
To:     Pankaj Gupta <pagupta@redhat.com>
Cc:     linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org,
        qemu-devel@nongnu.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, jack@suse.cz, mst@redhat.com,
        jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com,
        adilger kernel <adilger.kernel@dilger.ca>, zwisler@kernel.org,
        aarcange@redhat.com, dave jiang <dave.jiang@intel.com>,
        darrick wong <darrick.wong@oracle.com>,
        vishal l verma <vishal.l.verma@intel.com>, david@redhat.com,
        willy@infradead.org, hch@infradead.org, jmoyer@redhat.com,
        nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl,
        riel@surriel.com, yuval shaia <yuval.shaia@oracle.com>,
        stefanha@redhat.com, pbonzini@redhat.com,
        dan j williams <dan.j.williams@intel.com>, kwolf@redhat.com,
        tytso@mit.edu, xiaoguangrong eric <xiaoguangrong.eric@gmail.com>,
        cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com,
        smbarber@google.com
References: <20190426050039.17460-1-pagupta@redhat.com>
 <20190426050039.17460-3-pagupta@redhat.com>
 <3d6479ae-6c39-d614-f1d9-aa1978e2e438@google.com>
 <1555943483.27247564.1557313967518.JavaMail.zimbra@redhat.com>
Message-ID: <3d643ac5-ea1b-efba-9f42-31b2ed3ab5b0@google.com>
Date:   Wed, 8 May 2019 12:05:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1555943483.27247564.1557313967518.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/8/19 4:12 AM, Pankaj Gupta wrote:
> 
>>
>> On 4/25/19 10:00 PM, Pankaj Gupta wrote:
>>
>>> +void host_ack(struct virtqueue *vq)
>>> +{
>>> +	unsigned int len;
>>> +	unsigned long flags;
>>> +	struct virtio_pmem_request *req, *req_buf;
>>> +	struct virtio_pmem *vpmem = vq->vdev->priv;
>>> +
>>> +	spin_lock_irqsave(&vpmem->pmem_lock, flags);
>>> +	while ((req = virtqueue_get_buf(vq, &len)) != NULL) {
>>> +		req->done = true;
>>> +		wake_up(&req->host_acked);
>>> +
>>> +		if (!list_empty(&vpmem->req_list)) {
>>> +			req_buf = list_first_entry(&vpmem->req_list,
>>> +					struct virtio_pmem_request, list);
>>> +			list_del(&vpmem->req_list);
>>
>> Shouldn't it be rather `list_del(vpmem->req_list.next)`? We are trying to
>> unlink
>> first element of the list and `vpmem->req_list` is just the list head.
> 
> This looks correct. We are not deleting head but first entry in 'req_list'
> which is device corresponding list of pending requests.
> 
> Please see below:
> 
> /**
>  * Retrieve the first list entry for the given list pointer.
>  *
>  * Example:
>  * struct foo *first;
>  * first = list_first_entry(&bar->list_of_foos, struct foo, list_of_foos);
>  *
>  * @param ptr The list head
>  * @param type Data type of the list element to retrieve
>  * @param member Member name of the struct list_head field in the list element.
>  * @return A pointer to the first list element.
>  */
> #define list_first_entry(ptr, type, member) \
>     list_entry((ptr)->next, type, member)

Please look at this StackOverflow question:
https://stackoverflow.com/questions/19675419/deleting-first-element-of-a-list-h-list

Author asks about deleting first element of the queue. In our case
(and also in the question's author case), `vpmem->req_list` is not element
of any request struct and not an element of the list. It's just a list head storing 
`next` and `prev` pointers which are then pointing to respectively first and
last element of the list. We want to unlink the first element of the list,
so we need to pass pointer to the first element of the list to
the `list_del` function - that is, the `vpmem->req_list.next`.

Thank you,
Jakub Staron
